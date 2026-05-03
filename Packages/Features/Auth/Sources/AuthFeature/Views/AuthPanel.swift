import SwiftUI
import DesignSystem

/// Shared frame for every auth screen — title, description, content, optional
/// footer prompt with an inline action button.
struct AuthPanel<Content: View>: View {
    let title: String
    let description: String?
    let content: () -> Content
    let footerPrompt: String?
    let footerActionLabel: String?
    let onFooterAction: (() -> Void)?

    init(
        title: String,
        description: String? = nil,
        footerPrompt: String? = nil,
        footerActionLabel: String? = nil,
        onFooterAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.footerPrompt = footerPrompt
        self.footerActionLabel = footerActionLabel
        self.onFooterAction = onFooterAction
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.px24) {
            VStack(alignment: .leading, spacing: Tokens.Spacing.px8) {
                Text(title)
                    .font(Tokens.Typography.heading2)
                    .foregroundStyle(Tokens.Color.textPrimary)
                if let description {
                    Text(description)
                        .font(Tokens.Typography.bodySecondary)
                        .foregroundStyle(Tokens.Color.textSecondary)
                }
            }

            content()

            if let footerPrompt, let footerActionLabel, let onFooterAction {
                HStack(spacing: Tokens.Spacing.px4) {
                    Text(footerPrompt)
                        .font(Tokens.Typography.bodySecondary)
                        .foregroundStyle(Tokens.Color.textSecondary)
                    Button(footerActionLabel, action: onFooterAction)
                        .font(Tokens.Typography.bodySecondary)
                        .foregroundStyle(Tokens.Color.textPrimary)
                        .buttonStyle(.plain)
                }
            }
        }
        .padding(Tokens.Spacing.px24)
        .frame(maxWidth: 480, alignment: .leading)
        .background(Tokens.Color.surfacePrimary)
    }
}
