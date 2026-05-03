import Foundation
import Supabase

/// Owns the single shared `SupabaseClient` used by every repository in the app.
///
/// The client is created once from `AppConfig` and passed into repositories so
/// they stay testable (repository types accept a `SupabaseClient` or, in tests,
/// a mocked protocol-conformant alternative).
public final class SupabaseClientProvider: Sendable {
    public let client: SupabaseClient

    public init(config: AppConfig) {
        self.client = SupabaseClient(
            supabaseURL: config.supabaseURL,
            supabaseKey: config.supabaseAnonKey
        )
    }
}
