import SwiftUI
import DesignSystem
import Core

@main
struct arkivApp: App { // swiftlint:disable:this type_name — brand is lowercase.
    @State private var deps: AppDependencies = Self.makeInitialDependencies()

    var body: some Scene {
        WindowGroup {
            AuthGate()
                .environment(deps)
                .tint(Tokens.Color.arkivBluePrimary)
        }
        #if os(macOS)
        .defaultSize(width: 1100, height: 720)
        #endif
    }

    /// Build the dependency container from `Info.plist` on launch. Falls back to
    /// placeholder values if `Secrets.xcconfig` has not been set up yet — the app
    /// still renders, but any network call will fail with a clear error.
    private static func makeInitialDependencies() -> AppDependencies {
        do {
            let config = try AppConfig.fromMainBundle()
            return AppDependencies(config: config)
        } catch {
            #if DEBUG
            print("[arkiv] AppConfig unavailable, using placeholder: \(error)")
            #endif
            return AppDependencies.makePlaceholder()
        }
    }
}
