import SwiftUI
import DesignSystem

struct SignInView: View {
    @Bindable var viewModel: AuthViewModel
    let onSwitchToSignUp: () -> Void
    let onForgotPassword: () -> Void

    var body: some View {
        AuthPanel(
            title: "Sign In",
            description: "Enter your email below to sign in to your account.",
            footerPrompt: "Don't have an account?",
            footerActionLabel: "Sign Up",
            onFooterAction: onSwitchToSignUp
        ) {
            VStack(spacing: Tokens.Spacing.px16) {
                if let errorMessage = viewModel.errorMessage {
                    ErrorBanner(message: errorMessage)
                }

                TextField("Email", text: $viewModel.signInEmail)
                    .textFieldStyle(.arkiv)
                    .textContentType(.username)
                    #if os(iOS)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()

                SecureField("Password", text: $viewModel.signInPassword)
                    .textFieldStyle(.arkiv)
                    .textContentType(.password)

                Button(viewModel.activeAction == .signIn ? "Signing in…" : "Sign In") {
                    Task { await viewModel.signIn() }
                }
                .buttonStyle(.arkivPrimary)
                .disabled(!viewModel.signInEnabled)

                HStack {
                    Spacer()
                    Button("Forgot password?", action: onForgotPassword)
                        .font(Tokens.Typography.bodySecondary)
                        .foregroundStyle(Tokens.Color.textSecondary)
                        .buttonStyle(.plain)
                }
            }
        }
    }
}
