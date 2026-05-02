import SwiftUI
import DesignSystem
import Core

/// Entry point for the unauthenticated app. Routes between sign-in, sign-up, and
/// forgot-password panels. On successful auth, the parent `SessionStore` flips
/// to `.signedIn` and the host view swaps this out for the app shell.
public struct AuthRootView: View {
    private enum Screen {
        case signIn, signUp, forgotPassword
    }

    @State private var viewModel: AuthViewModel
    @State private var screen: Screen = .signIn

    public init(repository: AuthRepository) {
        _viewModel = State(wrappedValue: AuthViewModel(repository: repository))
    }

    public var body: some View {
        ZStack {
            Tokens.Color.surfacePrimary.ignoresSafeArea()

            ScrollView {
                VStack {
                    Spacer(minLength: Tokens.Spacing.px48)
                    Text("arkiv")
                        .font(Tokens.Typography.heading1)
                        .foregroundStyle(Tokens.Color.textPrimary)
                        .padding(.bottom, Tokens.Spacing.px24)

                    currentScreen
                        .transition(.opacity)

                    Spacer(minLength: Tokens.Spacing.px48)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onChange(of: screen) { _, _ in
            viewModel.clearFeedback()
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch screen {
        case .signIn:
            SignInView(
                viewModel: viewModel,
                onSwitchToSignUp: { screen = .signUp },
                onForgotPassword: { screen = .forgotPassword }
            )
        case .signUp:
            SignUpView(
                viewModel: viewModel,
                onSwitchToSignIn: { screen = .signIn }
            )
        case .forgotPassword:
            ForgotPasswordView(
                viewModel: viewModel,
                onBackToSignIn: { screen = .signIn }
            )
        }
    }
}
