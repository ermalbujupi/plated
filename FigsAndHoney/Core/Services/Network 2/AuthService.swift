import Foundation
import Observation

/// User-facing auth state. Observed by SwiftUI to decide which screen to show.
@Observable
@MainActor
final class AuthService {
    enum State: Equatable {
        case unknown            // first launch, before keychain probed
        case signedOut
        case signedIn(AuthUserDTO)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.unknown, .unknown):           return true
            case (.signedOut, .signedOut):       return true
            case (.signedIn(let a), .signedIn(let b)): return a.id == b.id
            default:                             return false
            }
        }
    }

    private(set) var state: State = .unknown

    private let api: AuthAPI
    private let tokenStore: AuthTokenStore
    private let client: APIClient

    /// Used to coalesce concurrent refreshes — only one in-flight refresh at a time.
    private var refreshTask: Task<Void, Error>?

    init(api: AuthAPI = AuthAPI(), tokenStore: AuthTokenStore = .shared, client: APIClient = .shared) {
        self.api = api
        self.tokenStore = tokenStore
        self.client = client

        // Wire APIClient's refresh hook so 401s trigger a refresh + retry.
        // Capture self weakly to avoid a retain cycle.
        client.refreshHandler = { [weak self] in
            try await self?.refreshTokens()
        }
    }

    /// Called once on app launch to determine whether the user is already signed in.
    func bootstrap() async {
        if await tokenStore.isAuthenticated {
            // We have tokens but haven't verified them. Optimistically mark signed in.
            // The first real API call will trigger a refresh if access token is stale.
            state = .signedIn(AuthUserDTO(id: "", email: nil, displayName: nil, avatarUrl: nil))
            // TODO: hit /user/profile to load real user data.
        } else {
            state = .signedOut
        }
    }

    // MARK: - Sign in flows

    func registerWithEmail(email: String, password: String, displayName: String?) async throws {
        let response = try await api.registerEmail(email: email, password: password, displayName: displayName)
        try await persist(response)
    }

    func signInWithEmail(email: String, password: String) async throws {
        let response = try await api.loginEmail(email: email, password: password)
        try await persist(response)
    }

    func signInWithApple(identityToken: String, displayName: String?) async throws {
        let response = try await api.loginWithApple(identityToken: identityToken, displayName: displayName)
        try await persist(response)
    }

    func signOut() async {
        // Best-effort server logout; ignore failures (we still clear local tokens).
        if let refresh = await tokenStore.refreshToken() {
            try? await api.logout(refreshToken: refresh)
        }
        await tokenStore.clear()
        state = .signedOut
    }

    // MARK: - Refresh

    /// Fetches a fresh access token using the stored refresh token. Throws if there's no
    /// refresh token or the call fails — caller should treat this as a forced sign-out.
    func refreshTokens() async throws {
        // If a refresh is already in flight, await it instead of starting a second one.
        if let existing = refreshTask {
            try await existing.value
            return
        }

        let task = Task<Void, Error> { [tokenStore, api] in
            guard let refresh = await tokenStore.refreshToken() else {
                throw APIError.unauthorized
            }
            let tokens = try await api.refresh(refreshToken: refresh)
            try await tokenStore.setTokens(access: tokens.accessToken, refresh: tokens.refreshToken)
        }
        refreshTask = task
        defer { refreshTask = nil }
        try await task.value
    }

    // MARK: - Helpers

    private func persist(_ response: AuthResponseDTO) async throws {
        try await tokenStore.setTokens(access: response.accessToken, refresh: response.refreshToken)
        state = .signedIn(response.user)
    }
}
