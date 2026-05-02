import SwiftUI
import DesignSystem

/// Phase 0 placeholder. Replaced in Phase 2 with the real games library list.
public struct GamesPlaceholderView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: ArkivSpacing.px8) {
            Text("Games")
                .font(ArkivTypography.heading3)
                .foregroundStyle(ArkivColor.textPrimary)
            Text("Library list coming in Phase 2.")
                .font(ArkivTypography.bodySecondary)
                .foregroundStyle(ArkivColor.textSecondary)
        }
        .padding(ArkivSpacing.px16)
        .frame(maxWidth: .infinity)
        .background(ArkivColor.surfaceTertiary)
    }
}

#Preview {
    GamesPlaceholderView()
}
