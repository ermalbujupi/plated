import Foundation
import Observation
import AuthenticationServices

/// Drives the auth screen UI: tracks loading state, surfaces errors, and
/// orchestrates the sign-in flows. The actual auth state (signed in vs out)
/// lives on `AuthService` — this VM is purely about *getting there*.
@Observable
@MainActor
final class AuthViewModel {
    enum Mode {
        case welcome           // primary buttons (Apple, "Continue with email")
        case email(EmailMode)  // email form sheet
    }

    enum EmailMode {
        case signIn
        case register
    }

    var mode: Mode = .welcome

    var emailField: String = ""
    var passwordField: String = ""
    var displayNameField: String = ""

    private(set) var isSubmitting: Bool = false
    private(set) var errorMessage: String?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    // MARK: - Apple

    /// Called from the SwiftUI `SignInWithAppleButton`'s `onCompletion`.
    /// Extracts the identity token + name and hands them to AuthService.
    func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let tokenData = credential.identityToken,
                  let token = String(data: tokenData, encoding: .utf8) else {
                errorMessage = "Apple didn't return an identity token. Try again."
                return
            }

            // `fullName` is only populated on the *first* sign-in for this Apple ID.
            let displayName = credential.fullName
                .flatMap { PersonNameComponentsFormatter().string(from: $0) }
                .flatMap { $0.isEmpty ? nil : $0 }

            performAppleSignIn(identityToken: token, displayName: displayName)

        case .failure(let error):
            // Cancellations are silent.
            if (error as NSError).code != ASAuthorizationError.canceled.rawValue {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func performAppleSignIn(identityToken: String, displayName: String?) {
        guard !isSubmitting else { return }
        isSubmitting = true
        errorMessage = nil

        Task { [authService] in
            defer { Task { @MainActor in self.isSubmitting = false } }
            do {
                try await authService.signInWithApple(
                    identityToken: identityToken,
                    displayName: displayName
                )
            } catch {
                await MainActor.run { self.errorMessage = error.localizedDescription }
            }
        }
    }

    // MARK: - Email

    func showEmailSheet(_ mode: EmailMode) {
        emailField = ""
        passwordField = ""
        displayNameField = ""
        errorMessage = nil
        self.mode = .email(mode)
    }

    func dismissEmailSheet() {
        mode = .welcome
        errorMessage = nil
    }

    func submitEmail(_ emailMode: EmailMode) {
        guard !isSubmitting else { return }

        let email = emailField.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField

        guard email.contains("@"), !password.isEmpty else {
            errorMessage = "Enter a valid email and password."
            return
        }
        if case .register = emailMode, password.count < 8 {
            errorMessage = "Password must be at least 8 characters."
            return
        }

        isSubmitting = true
        errorMessage = nil

        Task { [authService] in
            defer { Task { @MainActor in self.isSubmitting = false } }
            do {
                switch emailMode {
                case .signIn:
                    try await authService.signInWithEmail(email: email, password: password)
                case .register:
                    let name = displayNameField.trimmingCharacters(in: .whitespacesAndNewlines)
                    try await authService.registerWithEmail(
                        email: email,
                        password: password,
                        displayName: name.isEmpty ? nil : name
                    )
                }
                await MainActor.run { self.mode = .welcome }
            } catch {
                await MainActor.run { self.errorMessage = error.localizedDescription }
            }
        }
    }
}
