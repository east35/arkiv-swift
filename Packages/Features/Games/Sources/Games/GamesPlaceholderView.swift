import SwiftUI
import DesignSystem

/// Phase 0 placeholder. Replaced in Phase 2 with the real games library list.
public struct GamesPlaceholderView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: Tokens.Spacing.px8) {
            Text("Games")
                .font(Tokens.Typography.heading3)
                .foregroundStyle(Tokens.Color.textPrimary)
            Text("Library list coming in Phase 2.")
                .font(Tokens.Typography.bodySecondary)
                .foregroundStyle(Tokens.Color.textSecondary)
        }
        .padding(Tokens.Spacing.px16)
        .frame(maxWidth: .infinity)
        .background(Tokens.Color.surfaceTertiary)
    }
}

#Preview {
    GamesPlaceholderView()
}
