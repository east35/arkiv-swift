import SwiftUI

/// The arkiv primary button style — vivid brand surface (arkiv-blue), white label,
/// zero corner radius, dark hover overlay. Use on the most-prominent CTA per screen.
public struct PrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        ButtonBody(
            configuration: configuration,
            background: Tokens.Color.arkivBluePrimary,
            foreground: Tokens.Color.textWhite,
            pressedBackground: Tokens.Color.arkivBlueSecondary
        )
    }
}

/// Secondary button — tertiary surface, primary text.
public struct SecondaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        ButtonBody(
            configuration: configuration,
            background: Tokens.Color.surfaceTertiary,
            foreground: Tokens.Color.textPrimary,
            pressedBackground: Tokens.Color.surfaceTertiaryHover
        )
    }
}

private struct ButtonBody: View {
    let configuration: ButtonStyle.Configuration
    let background: Color
    let foreground: Color
    let pressedBackground: Color

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(Tokens.Typography.heading6)
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .frame(minHeight: Tokens.Size.interactionMinHeight)
            .background(configuration.isPressed ? pressedBackground : background)
            .opacity(isEnabled ? 1.0 : 0.5)
            .contentShape(Rectangle())
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static var arkivPrimary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

public extension ButtonStyle where Self == SecondaryButtonStyle {
    static var arkivSecondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}
