import Foundation

// MARK: - Wire types matching backend DTOs

struct AuthTokensDTO: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
}

struct AuthResponseDTO: Decodable, Sendable {
    let user: AuthUserDTO
    let accessToken: String
    let refreshToken: String
}

struct AuthUserDTO: Decodable, Sendable {
    let id: String
    let email: String?
    let displayName: String?
    let avatarUrl: String?
}

struct EmailRegisterBody: Encodable {
    let email: String
    let password: String
    let displayName: String?
}

struct EmailLoginBody: Encodable {
    let email: String
    let password: String
}

struct AppleAuthBody: Encodable {
    let identityToken: String
    /// Apple only returns the user's name on the very first sign-in. Pass it through.
    let displayName: String?
}

struct RefreshBody: Encodable {
    let refreshToken: String
}

// MARK: - AuthAPI

/// Thin wrapper around the `/auth/*` endpoints. No state — `AuthService` orchestrates.
struct AuthAPI {
    let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func registerEmail(email: String, password: String, displayName: String?) async throws -> AuthResponseDTO {
        try await client.post(
            "auth/email/register",
            body: EmailRegisterBody(email: email, password: password, displayName: displayName),
            authenticated: false
        )
    }

    func loginEmail(email: String, password: String) async throws -> AuthResponseDTO {
        try await client.post(
            "auth/email/login",
            body: EmailLoginBody(email: email, password: password),
            authenticated: false
        )
    }

    func loginWithApple(identityToken: String, displayName: String?) async throws -> AuthResponseDTO {
        try await client.post(
            "auth/apple",
            body: AppleAuthBody(identityToken: identityToken, displayName: displayName),
            authenticated: false
        )
    }

    func refresh(refreshToken: String) async throws -> AuthTokensDTO {
        try await client.post(
            "auth/refresh",
            body: RefreshBody(refreshToken: refreshToken),
            authenticated: false
        )
    }

    /// `DELETE /auth/session` — backend invalidates the refresh token server-side.
    /// Returns 204 No Content; we use the no-content variant of APIClient.
    func logout(refreshToken: String) async throws {
        try await client.sendNoContent(
            method: .DELETE,
            path: "auth/session",
            body: RefreshBody(refreshToken: refreshToken),
            authenticated: true
        )
    }
}
