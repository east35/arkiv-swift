import Foundation

/// Domain-level auth errors. Feature code should catch these, not raw Supabase errors.
public enum AuthError: Error, Equatable, LocalizedError, Sendable {
    /// Network, server, or unclassified error. `message` is a user-safe description.
    case unexpected(message: String)
    /// Credentials were rejected (wrong email / password).
    case invalidCredentials
    /// Email requires confirmation before sign-in can complete.
    case emailNotConfirmed
    /// Rate-limited by the auth backend.
    case rateLimited
    /// Sign-up requires email confirmation; no session was issued immediately.
    case signUpRequiresEmailConfirmation

    public var errorDescription: String? {
        switch self {
        case .unexpected(let message):
            return message
        case .invalidCredentials:
            return "That email and password don't match any account."
        case .emailNotConfirmed:
            return "Please confirm your email before signing in. Check your inbox."
        case .rateLimited:
            return "Too many attempts. Try again in a few minutes."
        case .signUpRequiresEmailConfirmation:
            return "Account created. Check your email to confirm it, then sign in."
        }
    }
}
