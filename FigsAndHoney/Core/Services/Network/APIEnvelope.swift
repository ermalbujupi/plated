import Foundation

/// Backend wraps every response in an envelope. We decode the envelope first,
/// then hand the inner `data` to the caller's expected type.
///
/// Success: `{ "status": "success", "data": <T>, "meta": <Meta?> }`
/// Error:   `{ "status": "error", "error": { "code", "message", "details" } }`
struct APIEnvelope<T: Decodable>: Decodable {
    let status: String
    let data: T?
    let meta: APIMeta?
    let error: APIErrorPayload?
}

struct APIMeta: Decodable, Sendable {
    let page: Int?
    let perPage: Int?
    let total: Int?
    let totalPages: Int?
}

struct APIErrorPayload: Decodable, Sendable {
    let code: String
    let message: String
    /// `details` can be anything (object, array, string). We don't need it
    /// for error display, so leave it untyped — `JSONValue` if you ever do.
}

/// A page of results. Use when an endpoint returns `{ data: [...], meta: {...} }`.
struct PaginatedResponse<Item: Decodable>: Decodable {
    let data: [Item]
    let meta: APIMeta?
}
