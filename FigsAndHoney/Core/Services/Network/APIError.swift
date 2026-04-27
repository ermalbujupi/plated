import Foundation

/// Errors surfaced by `APIClient`.
///
/// Mirrors the backend's error envelope:
/// `{ "status": "error", "error": { "code": "...", "message": "...", "details": ... } }`
enum APIError: LocalizedError, Sendable {
    /// Network-level failure (offline, DNS, TLS, timeout, etc.)
    case transport(underlying: Error)
    /// Response wasn't valid JSON or didn't match expected envelope shape.
    case decoding(underlying: Error)
    /// Server returned a structured error envelope.
    case server(status: Int, code: String, message: String)
    /// Auth token missing/expired and refresh failed. Consumer should sign user out.
    case unauthorized
    /// Non-2xx response that we couldn't parse as a structured error envelope.
    case unexpectedStatus(Int, body: String?)
    /// We tried to call a protected endpoint but no access token was available.
    case missingToken

    var errorDescription: String? {
        switch self {
        case .transport(let underlying):     return "Network error: \(underlying.localizedDescription)"
        case .decoding(let underlying):      return "Couldn't read server response: \(underlying.localizedDescription)"
        case .server(_, _, let message):     return message
        case .unauthorized:                  return "Your session expired. Please sign in again."
        case .unexpectedStatus(let s, _):    return "Unexpected server response (\(s))."
        case .missingToken:                  return "You need to sign in to do that."
        }
    }

    /// True if the caller should show a generic retry UI rather than a specific message.
    var isTransient: Bool {
        switch self {
        case .transport, .unexpectedStatus: return true
        default:                            return false
        }
    }
}
