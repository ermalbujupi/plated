import Foundation

/// Central configuration for the backend API.
///
/// To switch environments, change `Environment.current` or override via launch
/// argument `-APIEnvironment local|production`.
enum APIEnvironment: String {
    case local
    case production

    var baseURL: URL {
        switch self {
        case .local:      return URL(string: "http://localhost:3000/api/v1")!
        case .production: return URL(string: "https://figshoneybackend-production.up.railway.app/api/v1")!
        }
    }

    static var current: APIEnvironment {
        if let raw = ProcessInfo.processInfo.environment["API_ENVIRONMENT"],
           let env = APIEnvironment(rawValue: raw) {
            return env
        }
        // Default: production. Override via scheme env var when needed.
        return .production
    }
}

enum APIConfig {
    static var baseURL: URL { APIEnvironment.current.baseURL }
    /// Bumping this invalidates older cached auth tokens during a forced rotation.
    static let tokenSchemaVersion = 1
}
