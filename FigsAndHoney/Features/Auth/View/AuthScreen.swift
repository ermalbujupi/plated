import SwiftUI
import AuthenticationServices

/// Welcome screen shown when the user is signed out.
struct AuthScreen: View {
    @State private var viewModel: AuthViewModel

    init(authService: AuthService) {
        _viewModel = State(initialValue: AuthViewModel(authService: authService))
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // ─── Branding ─────────────────────────────────────
                VStack(spacing: 12) {
                    Text("🍯")
                        .font(.system(size: 64))
                    Text("Figs & Honey")
                        .font(.largeTitle.weight(.semibold))
                    Text("Slow, soulful cooking from\nthe people we admire.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // ─── Sign-in actions ──────────────────────────────
                VStack(spacing: 12) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        viewModel.handleAppleSignInResult(result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Button {
                        viewModel.showEmailSheet(.signIn)
                    } label: {
                        Text("Continue with email")
                            .font(.body.weight(.medium))
                            .frame(maxWidth: .infinity, minHeight: 52)
                    }
                    .buttonStyle(.bordered)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    HStack(spacing: 4) {
                        Text("New here?")
                            .foregroundStyle(.secondary)
                        Button("Create an account") {
                            viewModel.showEmailSheet(.register)
                        }
                    }
                    .font(.footnote)
                    .padding(.top, 4)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            if viewModel.isSubmitting {
                ProgressView().controlSize(.large)
                    .padding(24)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .sheet(isPresented: emailSheetPresented) {
            EmailAuthSheet(viewModel: viewModel)
        }
    }

    /// Binding that routes between `mode == .email` and `mode == .welcome`.
    private var emailSheetPresented: Binding<Bool> {
        Binding(
            get: {
                if case .email = viewModel.mode { return true }
                return false
            },
            set: { presented in
                if !presented { viewModel.dismissEmailSheet() }
            }
        )
    }
}
