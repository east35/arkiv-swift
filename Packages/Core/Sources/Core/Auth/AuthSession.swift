import Foundation

/// Swift-native representation of an authenticated session.
///
/// We do not expose `Supabase.Session` directly to feature code — repositories
/// translate Supabase types into these domain models so the auth layer can be
/// swapped or mocked without leaking backend types into views.
public struct AuthSession: Equatable, Sendable {
    public let userID: UUID
    public let email: String?
    public let isAnonymous: Bool

    public init(userID: UUID, email: String?, isAnonymous: Bool) {
        self.userID = userID
        self.email = email
        self.isAnonymous = isAnonymous
    }
}
