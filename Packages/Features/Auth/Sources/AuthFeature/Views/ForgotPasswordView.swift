import SwiftUI
import DesignSystem

struct ForgotPasswordView: View {
    @Bindable var viewModel: AuthViewModel
    let onBackToSignIn: () -> Void

    var body: some View {
        AuthPanel(
            title: "Reset Password",
            description: "Enter your email and we'll send you a reset link.",
            footerPrompt: "Remembered it?",
            footerActionLabel: "Back to Sign In",
            onFooterAction: onBackToSignIn
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

                TextField("Email", text: $viewModel.forgotPasswordEmail)
                    .textFieldStyle(.arkiv)
                    .textContentType(.emailAddress)
                    #if os(iOS)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()

                Button(viewModel.activeAction == .passwordReset ? "Sending…" : "Send Reset Link") {
                    Task { await viewModel.requestPasswordReset() }
                }
                .buttonStyle(.arkivPrimary)
                .disabled(!viewModel.forgotPasswordEnabled)
            }
        }
    }
}
