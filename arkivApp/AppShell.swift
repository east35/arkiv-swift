import SwiftUI
import DesignSystem
import Games

/// Top-level nav destinations surfaced in the shell. Phase 1 includes every
/// nav item the web app exposes, but only `games` routes to a real view — the
/// rest are placeholders that will get their feature modules in later phases.
enum NavDestination: String, Hashable, CaseIterable, Identifiable {
    case home, search, games, books, films, tv, collections, friends, settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .games: return "Games"
        case .books: return "Books"
        case .films: return "Films"
        case .tv: return "TV"
        case .collections: return "Collections"
        case .friends: return "Friends"
        case .settings: return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .games: return "gamecontroller"
        case .books: return "book"
        case .films: return "film"
        case .tv: return "tv"
        case .collections: return "square.stack"
        case .friends: return "person.2"
        case .settings: return "gearshape"
        }
    }
}

/// Signed-in app shell. Adaptive:
/// - iPhone (compact) → `TabView`
/// - iPad / Mac (regular) → `NavigationSplitView`
struct AppShell: View {
    @Environment(AppDependencies.self) private var deps
    @State private var selection: NavDestination = .home

    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            compactTabView
        } else {
            splitView
        }
        #else
        splitView
        #endif
    }

    // MARK: - Tab layout (iPhone)

    private var compactTabView: some View {
        TabView(selection: $selection) {
            ForEach(NavDestination.allCases) { destination in
                NavigationStack {
                    destinationView(for: destination)
                        .navigationTitle(destination.title)
                }
                .tabItem {
                    Label(destination.title, systemImage: destination.systemImage)
                }
                .tag(destination)
            }
        }
    }

    // MARK: - Split layout (iPad / Mac)

    private var splitView: some View {
        let optionalSelection = Binding<NavDestination?>(
            get: { selection },
            set: { selection = $0 ?? selection }
        )
        return NavigationSplitView {
            List(NavDestination.allCases, selection: optionalSelection) { destination in
                Label(destination.title, systemImage: destination.systemImage)
                    .tag(destination)
            }
            .navigationTitle("arkiv")
        } detail: {
            NavigationStack {
                destinationView(for: selection)
                    .navigationTitle(selection.title)
            }
        }
    }

    // MARK: - Destination routing

    @ViewBuilder
    private func destinationView(for destination: NavDestination) -> some View {
        switch destination {
        case .games:
            GamesPlaceholderView()
        case .settings:
            SettingsPlaceholderView()
        default:
            EmptyStateView(
                title: destination.title,
                description: "Coming in a later phase."
            )
        }
    }
}

/// Phase 1 settings placeholder — exposes sign-out so the auth loop can be verified
/// end-to-end even before we build the full Settings feature in Phase 5.
private struct SettingsPlaceholderView: View {
    @Environment(AppDependencies.self) private var deps

    var body: some View {
        VStack(spacing: Tokens.Spacing.px16) {
            if case .signedIn(let session) = deps.sessionStore.phase, let email = session.email {
                Text("Signed in as")
                    .font(Tokens.Typography.bodySecondary)
                    .foregroundStyle(Tokens.Color.textSecondary)
                Text(email)
                    .font(Tokens.Typography.heading5)
                    .foregroundStyle(Tokens.Color.textPrimary)
            }

            Button("Sign Out") {
                Task { await deps.sessionStore.signOut() }
            }
            .buttonStyle(.arkivSecondary)
            .frame(maxWidth: 320)
        }
        .padding(Tokens.Spacing.px24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Tokens.Color.surfacePrimary)
    }
}
