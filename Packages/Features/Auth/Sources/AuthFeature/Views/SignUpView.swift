import SwiftUI
import DesignSystem

struct SignUpView: View {
    @Bindable var viewModel: AuthViewModel
    let onSwitchToSignIn: () -> Void

    var body: some View {
        AuthPanel(
            title: "Create Account",
            description: "Enter your details below to create a new account.",
            footerPrompt: "Already have an account?",
            footerActionLabel: "Sign In",
            onFooterAction: onSwitchToSignIn
        ) {
            VStack(spacing: Tokens.Spacing.px16) {
                if let errorMessage = viewModel.errorMessage {
                    ErrorBanner(message: errorMessage)
                }
                if let infoMessage = viewModel.infoMessage {
                    Text(infoMessage)
                        .font(Tokens.Typography.bodySecondary)
                        .foregroundStyle(Tokens.Color.textPrimary)
                        .padding(Tokens.Spacing.px12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Tokens.Color.surfaceTertiary)
                }

                TextField("Email", text: $viewModel.signUpEmail)
                    .textFieldStyle(.arkiv)
                    .textContentType(.emailAddress)
                    #if os(iOS)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()

                SecureField("Password (8+ characters)", text: $viewModel.signUpPassword)
                    .textFieldStyle(.arkiv)
                    .textContentType(.newPassword)

                SecureField("Confirm password", text: $viewModel.signUpConfirmPassword)
                    .textFieldStyle(.arkiv)
                    .textContentType(.newPassword)

                Button(viewModel.activeAction == .signUp ? "Creating account…" : "Sign Up") {
                    Task { await viewModel.signUp() }
                }
                .buttonStyle(.arkivPrimary)
                .disabled(!viewModel.signUpEnabled)
            }
        }
    }
}
