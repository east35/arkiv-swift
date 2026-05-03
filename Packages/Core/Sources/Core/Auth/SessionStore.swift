import Foundation
import Observation

/// Shared session state used by the app shell to decide between the auth flow and
/// the signed-in shell. Also exposes `signOut()` so screens that don't have a
/// direct reference to the auth repository (e.g. Settings) can trigger sign-out.
@MainActor
@Observable
public final class SessionStore {
    public enum Phase: Equatable {
        /// First-run hydration — show a loading splash, not the auth screen.
        case loading
        /// No active session; the app should show auth.
        case signedOut
        /// A session is active.
        case signedIn(AuthSession)
    }

    public private(set) var phase: Phase = .loading

    private let repository: AuthRepository
    private var watcherTask: Task<Void, Never>?

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    /// Start watching session changes. Idempotent — safe to call multiple times.
    public func start() {
        guard watcherTask == nil else { return }
        watcherTask = Task { [repository, weak self] in
            for await session in repository.sessionChanges() {
                guard let self else { return }
                await MainActor.run {
                    self.phase = session.map(Phase.signedIn) ?? .signedOut
                }
            }
        }
    }

    public func stop() {
        watcherTask?.cancel()
        watcherTask = nil
    }

    public func signOut() async {
        do {
            try await repository.signOut()
        } catch {
            // If sign-out fails, the session watcher will correct any drift.
            // A toast at the call site is fine; nothing structural to do here.
        }
    }

    // No `deinit` cancellation: `watcherTask` is `@MainActor`-isolated and
    // deinit is nonisolated. The task captures `[weak self]` so it does not
    // retain the store; call `stop()` explicitly if you need early cleanup.
}
