import Foundation
import Core

/// Container for app-level singletons. Built once at launch from `AppConfig`,
/// then passed into views via the environment (`@Environment(AppDependencies.self)`).
///
/// Keeping this small and explicit avoids a larger DI framework. Feature modules
/// declare what they need (e.g. an `AuthRepository`) and the app target wires it.
@MainActor
@Observable
final class AppDependencies {
    let config: AppConfig
    let supabase: SupabaseClientProvider
    let authRepository: AuthRepository
    let sessionStore: SessionStore

    init(config: AppConfig) {
        self.config = config
        let supabase = SupabaseClientProvider(config: config)
        self.supabase = supabase
        let authRepository = SupabaseAuthRepository(client: supabase.client)
        self.authRepository = authRepository
        self.sessionStore = SessionStore(repository: authRepository)
    }

    /// Fallback dependencies used when `AppConfig` can't be read from Info.plist.
    /// Keeps the app launchable in Previews and during first-run local builds where
    /// `Secrets.xcconfig` hasn't been set up yet. Any real network call will fail
    /// until the user provides real values in Secrets.xcconfig.
    static func makePlaceholder() -> AppDependencies {
        let config = AppConfig(
            supabaseURL: URL(string: "https://placeholder.supabase.co")!,
            supabaseAnonKey: "placeholder"
        )
        return AppDependencies(config: config)
    }
}
