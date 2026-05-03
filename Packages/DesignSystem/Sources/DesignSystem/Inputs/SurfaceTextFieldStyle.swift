import SwiftUI

/// The arkiv text-field style — flat surface, no border, inset focus outline.
///
/// Use via `.textFieldStyle(.arkiv)`.
public struct SurfaceTextFieldStyle: TextFieldStyle {
    public init() {}

    // swiftlint:disable:next identifier_name
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(Tokens.Typography.bodyPrimary)
            .foregroundStyle(Tokens.Color.textPrimary)
            .padding(.horizontal, Tokens.Spacing.px16)
            .frame(minHeight: Tokens.Size.interactionMinHeight)
            .background(Tokens.Color.surfaceTertiary)
    }
}

public extension TextFieldStyle where Self == SurfaceTextFieldStyle {
    static var arkiv: SurfaceTextFieldStyle { SurfaceTextFieldStyle() }
}
