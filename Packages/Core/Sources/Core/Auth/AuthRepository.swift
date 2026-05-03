import Foundation

/// Auth operations consumed by feature code. Implemented by `SupabaseAuthRepository`
/// in production and a mock in tests.
public protocol AuthRepository: Sendable {
    /// Current session, or `nil` if signed out. Hydrated on init by the implementation.
    func currentSession() async -> AuthSession?

    /// Stream of session changes. Emits the current session immediately on subscribe,
    /// then every subsequent change (sign-in, sign-out, token refresh).
    func sessionChanges() -> AsyncStream<AuthSession?>

    /// Sign in with email + password. Returns the resulting session on success.
    func signIn(email: String, password: String) async throws -> AuthSession

    /// Create an account. On projects that require email confirmation, this throws
    /// `AuthError.signUpRequiresEmailConfirmation` (not an error in the UX sense —
    /// treat it as a "check your email" outcome).
    func signUp(email: String, password: String) async throws -> AuthSession

    /// End the current session.
    func signOut() async throws

    /// Send a password-reset email to the given address.
    func requestPasswordReset(email: String) async throws
}
