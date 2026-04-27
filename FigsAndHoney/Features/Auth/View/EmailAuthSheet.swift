import SwiftUI

/// Email + password form for sign-in or registration. Driven by `AuthViewModel.mode`.
struct EmailAuthSheet: View {
    @Bindable var viewModel: AuthViewModel
    @FocusState private var focus: Field?

    private enum Field {
        case email, password, name
    }

    var body: some View {
        NavigationStack {
            Form {
                if isRegister {
                    Section {
                        TextField("Display name (optional)", text: $viewModel.displayNameField)
                            .textContentType(.name)
                            .focused($focus, equals: .name)
                    }
                }

                Section {
                    TextField("Email", text: $viewModel.emailField)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focus, equals: .email)

                    SecureField("Password", text: $viewModel.passwordField)
                        .textContentType(isRegister ? .newPassword : .password)
                        .focused($focus, equals: .password)
                } footer: {
                    if isRegister {
                        Text("At least 8 characters.")
                    }
                }

                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button(action: submit) {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text(isRegister ? "Create account" : "Sign in")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.medium)
                        }
                    }
                    .disabled(viewModel.isSubmitting)
                }
            }
            .navigationTitle(isRegister ? "Sign up" : "Sign in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.dismissEmailSheet()
                    }
                }
            }
            .onAppear {
                focus = isRegister ? .name : .email
            }
        }
        .interactiveDismissDisabled(viewModel.isSubmitting)
    }

    private var isRegister: Bool {
        if case .email(.register) = viewModel.mode { return true }
        return false
    }

    private func submit() {
        let mode: AuthViewModel.EmailMode = isRegister ? .register : .signIn
        viewModel.submitEmail(mode)
    }
}
