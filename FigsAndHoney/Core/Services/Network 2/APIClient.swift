import Foundation

/// HTTP method enum so callers don't pass raw strings.
enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

/// The single network entry point for the app.
///
/// Responsibilities:
/// - Build URLs from path + query
/// - Inject `Authorization: Bearer` header for protected calls
/// - Decode the `{ status, data, meta }` envelope
/// - Map error envelopes → `APIError`
/// - On 401, attempt one refresh + retry, then surface `.unauthorized`
final class APIClient {
    static let shared = APIClient()

    private let baseURL: URL
    private let session: URLSession
    private let tokenStore: AuthTokenStore
    private let decoder: JSONDecoder

    /// Set lazily by the auth module to avoid a hard import cycle. Without this,
    /// the client surfaces `.unauthorized` instead of trying to refresh.
    var refreshHandler: (@Sendable () async throws -> Void)?

    init(
        baseURL: URL = APIConfig.baseURL,
        session: URLSession = .shared,
        tokenStore: AuthTokenStore = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenStore = tokenStore

        let decoder = JSONDecoder()
        // Backend sends ISO8601 timestamps with fractional seconds (e.g. "2026-04-21T19:42:13.456Z").
        // The default `.iso8601` strategy doesn't handle fractional seconds, so use a custom one.
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)
            if let date = APIClient.iso8601WithFractional.date(from: raw) { return date }
            if let date = APIClient.iso8601Plain.date(from: raw)         { return date }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unrecognized ISO8601 date: \(raw)"
            )
        }
        self.decoder = decoder
    }

    // MARK: - Public API

    /// GET that decodes the envelope's `data` field into `T`.
    func get<T: Decodable>(
        _ path: String,
        query: [String: String?] = [:],
        authenticated: Bool = false,
        as: T.Type = T.self
    ) async throws -> T {
        try await send(method: .GET, path: path, query: query, body: Optional<EmptyBody>.none, authenticated: authenticated)
    }

    /// POST with optional JSON body.
    func post<Body: Encodable, T: Decodable>(
        _ path: String,
        body: Body? = nil,
        authenticated: Bool = false,
        as: T.Type = T.self
    ) async throws -> T {
        try await send(method: .POST, path: path, query: [:], body: body, authenticated: authenticated)
    }

    func put<Body: Encodable, T: Decodable>(
        _ path: String,
        body: Body? = nil,
        authenticated: Bool = true,
        as: T.Type = T.self
    ) async throws -> T {
        try await send(method: .PUT, path: path, query: [:], body: body, authenticated: authenticated)
    }

    func delete<T: Decodable>(
        _ path: String,
        authenticated: Bool = true,
        as: T.Type = T.self
    ) async throws -> T {
        try await send(method: .DELETE, path: path, query: [:], body: Optional<EmptyBody>.none, authenticated: authenticated)
    }

    /// Variant for endpoints that return 204 No Content (or any 2xx with empty body).
    /// Skips envelope parsing entirely — only checks the status code.
    func sendNoContent<Body: Encodable>(
        method: HTTPMethod,
        path: String,
        body: Body? = nil,
        authenticated: Bool = true
    ) async throws {
        let request = try await buildRequest(
            method: method, path: path, query: [:], body: body, authenticated: authenticated
        )

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(underlying: error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.unexpectedStatus(-1, body: nil)
        }
        guard (200..<300).contains(http.statusCode) else {
            // Try to parse a structured error envelope, otherwise surface raw status.
            if let envelope = try? decoder.decode(APIEnvelope<EmptyBody>.self, from: data),
               let err = envelope.error {
                throw APIError.server(status: http.statusCode, code: err.code, message: err.message)
            }
            if http.statusCode == 401 { throw APIError.unauthorized }
            throw APIError.unexpectedStatus(http.statusCode, body: String(data: data, encoding: .utf8))
        }
    }

    // MARK: - Core request pipeline

    private func send<Body: Encodable, T: Decodable>(
        method: HTTPMethod,
        path: String,
        query: [String: String?],
        body: Body?,
        authenticated: Bool,
        isRetry: Bool = false
    ) async throws -> T {
        let request = try await buildRequest(
            method: method, path: path, query: query, body: body, authenticated: authenticated
        )

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(underlying: error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.unexpectedStatus(-1, body: nil)
        }

        // 401: try one refresh then retry, but only if we have a handler and haven't already retried.
        if http.statusCode == 401, !isRetry, authenticated, let refresh = refreshHandler {
            do {
                try await refresh()
                return try await send(
                    method: method, path: path, query: query,
                    body: body, authenticated: authenticated, isRetry: true
                )
            } catch {
                await tokenStore.clear()
                throw APIError.unauthorized
            }
        }

        return try parse(data: data, statusCode: http.statusCode)
    }

    private func buildRequest<Body: Encodable>(
        method: HTTPMethod,
        path: String,
        query: [String: String?],
        body: Body?,
        authenticated: Bool
    ) async throws -> URLRequest {
        // Compose the URL — strip leading slash from `path` so we always
        // append cleanly to `baseURL` regardless of caller style.
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path.trimmingPrefix("/")),
            resolvingAgainstBaseURL: false
        )
        let nonNilQuery = query.compactMapValues { $0 }
        if !nonNilQuery.isEmpty {
            components?.queryItems = nonNilQuery.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components?.url else {
            throw APIError.transport(underlying: URLError(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }

        if authenticated {
            guard let token = await tokenStore.accessToken() else {
                throw APIError.missingToken
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func parse<T: Decodable>(data: Data, statusCode: Int) throws -> T {
        // Try to decode as our envelope shape first.
        do {
            let envelope = try decoder.decode(APIEnvelope<T>.self, from: data)
            if envelope.status == "success", let payload = envelope.data {
                return payload
            }
            if envelope.status == "error", let err = envelope.error {
                if statusCode == 401 { throw APIError.unauthorized }
                throw APIError.server(status: statusCode, code: err.code, message: err.message)
            }
            // Envelope shape, but neither branch had usable data.
            throw APIError.unexpectedStatus(statusCode, body: String(data: data, encoding: .utf8))
        } catch let apiError as APIError {
            throw apiError
        } catch let decodingError as DecodingError {
            // Data decoded as envelope failed — could be a 204-style empty body,
            // or a non-envelope response. Surface as decoding error with body for debugging.
            #if DEBUG
            print("[APIClient] decoding failed: \(decodingError)")
            print("[APIClient] body: \(String(data: data, encoding: .utf8) ?? "<binary>")")
            #endif
            throw APIError.decoding(underlying: decodingError)
        }
    }

    // MARK: - Date formatters

    private static let iso8601WithFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let iso8601Plain: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()
}

/// Placeholder type used when a request needs no body, or when we need a
/// concrete `Decodable` to parse the envelope shape without caring about `data`.
private struct EmptyBody: Codable {}

private extension String {
    func trimmingPrefix(_ prefix: String) -> String {
        hasPrefix(prefix) ? String(dropFirst(prefix.count)) : self
    }
}
