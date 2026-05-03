import SwiftUI

/// Centered progress indicator for screen-level loading states.
public struct LoadingView: View {
    public let label: String?

    public init(label: String? = nil) {
        self.label = label
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.px12) {
            ProgressView()
            if let label {
                Text(label)
                    .font(Tokens.Typography.bodySecondary)
                    .foregroundStyle(Tokens.Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Tokens.Color.surfacePrimary)
    }
}
