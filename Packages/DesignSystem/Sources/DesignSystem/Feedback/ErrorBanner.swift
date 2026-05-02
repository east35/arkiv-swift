import SwiftUI

/// Inline error banner — red surface, white text, zero radius. Use above forms.
public struct ErrorBanner: View {
    public let message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        Text(message)
            .font(Tokens.Typography.bodySecondary)
            .foregroundStyle(Tokens.Color.textWhite)
            .padding(.horizontal, Tokens.Spacing.px16)
            .padding(.vertical, Tokens.Spacing.px8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Tokens.Color.ragebaitRedPrimary)
    }
}
