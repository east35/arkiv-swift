import Foundation
import Observation
import Core

/// Which action is currently in flight. Used to drive per-button spinners and
/// to gate concurrent submissions.
public enum AuthAction: Equatable, Sendable {
    case signIn
    case signUp
    case passwordReset
}

/// Observable view-state for all auth screens. A single view model backs sign-in,
/// sign-up, and password-reset because they share a lot of state (email, loading,
/// error) and the screens themselves are thin.
@MainActor
@Observable
public final class AuthViewModel {
    // MARK: - Inputs

    public var signInEmail: String = ""
    public var signInPassword: String = ""

    public var signUpEmail: String = ""
    public var signUpPassword: String = ""
    public var signUpConfirmPassword: String = ""

    public var forgotPasswordEmail: String = ""

    // MARK: - Output state

    public private(set) var activeAction: AuthAction?
    public private(set) var errorMessage: String?
    public private(set) var infoMessage: String?

    // MARK: - Dependencies

    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    // MARK: - Derived validation

    public var signInEnabled: Bool {
        activeAction == nil
            && Self.isValidEmail(signInEmail)
            && !signInPassword.isEmpty
    }

    public var signUpEnabled: Bool {
        activeAction == nil
            && Self.isValidEmail(signUpEmail)
            && signUpPassword.count >= 8
            && signUpPassword == signUpConfirmPassword
    }

    public var forgotPasswordEnabled: Bool {
        activeAction == nil && Self.isValidEmail(forgotPasswordEmail)
    }

    // MARK: - Actions

    public func signIn() async {
        guard signInEnabled else { return }
        clearFeedback()
        activeAction = .signIn
        defer { activeAction = nil }
        do {
            _ = try await repository.signIn(
                email: signInEmail.trimmingCharacters(in: .whitespaces),
                password: signInPassword
            )
            // Session change will propagate via SessionStore; no further action here.
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func signUp() async {
        guard signUpEnabled else { return }
        clearFeedback()
        activeAction = .signUp
        defer { activeAction = nil }
        do {
            _ = try await repository.signUp(
                email: signUpEmail.trimmingCharacters(in: .whitespaces),
                password: signUpPassword
            )
            // Session was issued immediately — propagates via SessionStore.
        } catch AuthError.signUpRequiresEmailConfirmation {
            infoMessage = AuthError.signUpRequiresEmailConfirmation.errorDescription
            signUpPassword = ""
            signUpConfirmPassword = ""
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func requestPasswordReset() async {
        guard forgotPasswordEnabled else { return }
        clearFeedback()
        activeAction = .passwordReset
        defer { activeAction = nil }
        do {
            try await repository.requestPasswordReset(
                email: forgotPasswordEmail.trimmingCharacters(in: .whitespaces)
            )
            infoMessage = "If an account exists for that email, you'll receive a reset link shortly."
            forgotPasswordEmail = ""
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func clearFeedback() {
        errorMessage = nil
        infoMessage = nil
    }

    // MARK: - Helpers

    /// Pragmatic email check — not RFC-5322, but weeds out obvious typos.
    static func isValidEmail(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }
        let parts = trimmed.split(separator: "@")
        guard parts.count == 2, !parts[0].isEmpty else { return false }
        let host = parts[1]
        return host.contains(".") && host.last != "."
    }
}
