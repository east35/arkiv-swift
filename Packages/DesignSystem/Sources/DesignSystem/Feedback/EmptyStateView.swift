import SwiftUI

/// Empty-state placeholder — title + optional description, centered in available space.
public struct EmptyStateView: View {
    public let title: String
    public let description: String?

    public init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.px8) {
            Text(title)
                .font(Tokens.Typography.heading4)
                .foregroundStyle(Tokens.Color.textPrimary)
            if let description {
                Text(description)
                    .font(Tokens.Typography.bodySecondary)
                    .foregroundStyle(Tokens.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Tokens.Spacing.px24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
