import SwiftUI
import DesignSystem
import Games

@main
struct ArkivApp: App {
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
        VStack(spacing: ArkivSpacing.px16) {
            Text("Arkiv")
                .font(ArkivTypography.heading1)
                .foregroundStyle(ArkivColor.textPrimary)

            Text("Phase 0 foundation")
                .font(ArkivTypography.bodyPrimary)
                .foregroundStyle(ArkivColor.textSecondary)

            GamesPlaceholderView()
        }
        .padding(ArkivSpacing.px24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ArkivColor.surfacePrimary)
    }
}

#Preview {
    RootView()
}
