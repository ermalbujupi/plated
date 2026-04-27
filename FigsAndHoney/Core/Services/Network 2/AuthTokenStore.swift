import Foundation

/// Holds the access + refresh JWTs and persists them in the Keychain.
///
/// `actor` because access/refresh tokens can be read/written from any thread
/// (the URLSession completion thread, the auth flow, the refresh task, etc.)
/// and we need to serialize updates to avoid two concurrent refreshes.
actor AuthTokenStore {
    static let shared = AuthTokenStore()

    private let keychain: KeychainService
    private let accessKey  = "auth.accessToken.v\(APIConfig.tokenSchemaVersion)"
    private let refreshKey = "auth.refreshToken.v\(APIConfig.tokenSchemaVersion)"

    /// Cached in-memory copies so we don't hit the keychain on every request.
    private var accessTokenCache:  String?
    private var refreshTokenCache: String?
    private var loaded = false

    init(keychain: KeychainService = .shared) {
        self.keychain = keychain
    }

    func accessToken() -> String? {
        loadIfNeeded()
        return accessTokenCache
    }

    func refreshToken() -> String? {
        loadIfNeeded()
        return refreshTokenCache
    }

    func setTokens(access: String, refresh: String) throws {
        try keychain.set(access,  for: accessKey)
        try keychain.set(refresh, for: refreshKey)
        accessTokenCache  = access
        refreshTokenCache = refresh
        loaded = true
    }

    func setAccessToken(_ access: String) throws {
        try keychain.set(access, for: accessKey)
        accessTokenCache = access
    }

    func clear() {
        keychain.delete(accessKey)
        keychain.delete(refreshKey)
        accessTokenCache  = nil
        refreshTokenCache = nil
        loaded = true
    }

    var isAuthenticated: Bool {
        loadIfNeeded()
        return accessTokenCache != nil && refreshTokenCache != nil
    }

    private func loadIfNeeded() {
        guard !loaded else { return }
        accessTokenCache  = keychain.get(accessKey)
        refreshTokenCache = keychain.get(refreshKey)
        loaded = true
    }
}
