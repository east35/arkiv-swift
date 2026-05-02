import SwiftUI
import DesignSystem
import Core
import AuthFeature

/// Decides between the auth flow and the signed-in shell based on the session
/// phase held by `SessionStore`. Also kicks the session watcher on first appear.
struct AuthGate: View {
    @Environment(AppDependencies.self) private var deps

    var body: some View {
        Group {
            switch deps.sessionStore.phase {
            case .loading:
                LoadingView(label: "Restoring session…")
            case .signedOut:
                AuthRootView(repository: deps.authRepository)
            case .signedIn:
                AppShell()
            }
        }
        .task {
            deps.sessionStore.start()
        }
    }
}
