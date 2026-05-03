import Foundation
import Supabase
import Auth

/// Production `AuthRepository` backed by the Supabase Swift SDK.
public final class SupabaseAuthRepository: AuthRepository {
    private let client: SupabaseClient
    private let captchaProvider: CaptchaTokenProvider?

    public init(client: SupabaseClient, captchaProvider: CaptchaTokenProvider? = nil) {
        self.client = client
        self.captchaProvider = captchaProvider
    }

    public func currentSession() async -> AuthSession? {
        do {
            let session = try await client.auth.session
            return Self.map(session: session)
        } catch {
            return nil
        }
    }

    public func sessionChanges() -> AsyncStream<AuthSession?> {
        AsyncStream { continuation in
            let task = Task { [client] in
                // Supabase's `authStateChanges` emits the initial session then each change.
                for await (_, session) in client.auth.authStateChanges {
                    if Task.isCancelled { break }
                    continuation.yield(session.map(Self.map(session:)))
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    public func signIn(email: String, password: String) async throws -> AuthSession {
        do {
            let token = try await captchaProvider?.fetchToken()
            let session = try await client.auth.signIn(email: email, password: password, captchaToken: token)
            return Self.map(session: session)
        } catch {
            throw Self.translate(error)
        }
    }

    public func signUp(email: String, password: String) async throws -> AuthSession {
        do {
            let token = try await captchaProvider?.fetchToken()
            let response = try await client.auth.signUp(email: email, password: password, captchaToken: token)
            if let session = response.session {
                return Self.map(session: session)
            }
            // Project requires email confirmation; no session issued yet.
            throw AuthError.signUpRequiresEmailConfirmation
        } catch let error as AuthError {
            throw error
        } catch {
            throw Self.translate(error)
        }
    }

    public func signOut() async throws {
        do {
            try await client.auth.signOut()
        } catch {
            throw Self.translate(error)
        }
    }

    public func requestPasswordReset(email: String) async throws {
        do {
            try await client.auth.resetPasswordForEmail(email)
        } catch {
            throw Self.translate(error)
        }
    }

    // MARK: - Mapping

    private static func map(session: Session) -> AuthSession {
        AuthSession(
            userID: session.user.id,
            email: session.user.email,
            isAnonymous: session.user.isAnonymous
        )
    }

    private static func translate(_ error: Error) -> AuthError {
        if let authError = error as? Auth.AuthError {
            // Supabase auth errors expose a message; map known shapes conservatively.
            let message = authError.errorDescription ?? "\(authError)"
            let lower = message.lowercased()
            if lower.contains("invalid login credentials") || lower.contains("invalid email or password") {
                return .invalidCredentials
            }
            if lower.contains("email not confirmed") {
                return .emailNotConfirmed
            }
            if lower.contains("rate limit") {
                return .rateLimited
            }
            return .unexpected(message: message)
        }
        return .unexpected(message: error.localizedDescription)
    }
}
