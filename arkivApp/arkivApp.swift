import SwiftUI
import DesignSystem
import Games

@main
struct arkivApp: App { // swiftlint:disable:this type_name — brand is lowercase.
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        #if os(macOS)
        .defaultSize(width: 1100, height: 720)
        #endif
    }
}

struct RootView: View {
    var body: some View {
        // Phase 0 placeholder. Phase 1 replaces this with the auth gate + app shell.
        VStack(spacing: Tokens.Spacing.px16) {
            Text("arkiv")
                .font(Tokens.Typography.heading1)
                .foregroundStyle(Tokens.Color.textPrimary)

            Text("Phase 0 foundation")
                .font(Tokens.Typography.bodyPrimary)
                .foregroundStyle(Tokens.Color.textSecondary)

            GamesPlaceholderView()
        }
        .padding(Tokens.Spacing.px24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Tokens.Color.surfacePrimary)
    }
}

#Preview {
    RootView()
}
