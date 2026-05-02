import SwiftUI

public extension Tokens {

    /// Color tokens — ported from `src/globals.css` in the web repo.
    ///
    /// Brand colors are mode-invariant; surface / text tokens adapt between light and
    /// dark mode. No raw hex values should ever be used at the call site — always reach
    /// for a token here.
    enum Color {

        // MARK: - Grayscale primitives (mode-adaptive)

        public static let grayscale000 = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xFFFFFF), dark: SwiftUI.Color(hex: 0x000000))
        public static let grayscale100 = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xE5E5E5), dark: SwiftUI.Color(hex: 0x171717))
        public static let grayscale200 = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xA1A1A1), dark: SwiftUI.Color(hex: 0x262626))
        public static let grayscale500 = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0x2F2F2F), dark: SwiftUI.Color(hex: 0x737373))
        public static let grayscale800 = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0x171717), dark: SwiftUI.Color(hex: 0xE5E5E5))
        public static let grayscale900 = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0x0A0A0A), dark: SwiftUI.Color(hex: 0xF5F5F5))
        public static let grayscale1000 = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0x000000), dark: SwiftUI.Color(hex: 0xFFFFFF))

        // MARK: - Brand (mode-invariant)

        public static let arkivBluePrimary = SwiftUI.Color(hex: 0x1F19F6)
        public static let arkivBlueSecondary = SwiftUI.Color(hex: 0x060531)

        public static let ragebaitRedPrimary = SwiftUI.Color(hex: 0xFB2C36)
        public static let ragebaitRedSecondary = SwiftUI.Color(hex: 0x330001)

        public static let goblinGreenPrimary = SwiftUI.Color(hex: 0x04C950)
        public static let goblinGreenSecondary = SwiftUI.Color(hex: 0x00210C)

        public static let purpleDrankPrimary = SwiftUI.Color(hex: 0xAD46FF)
        public static let purpleDrankSecondary = SwiftUI.Color(hex: 0x1E0332)

        // MARK: - Text

        public static let textPrimary = grayscale1000
        public static let textSecondary = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0x737373), dark: SwiftUI.Color(hex: 0xA1A1A1))
        public static let textTertiary = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xA1A1A1), dark: SwiftUI.Color(hex: 0x262626))
        public static let textCritical = ragebaitRedPrimary
        public static let textWhite = SwiftUI.Color(hex: 0xFFFFFF)
        public static let textPrimaryInverted = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xFFFFFF), dark: SwiftUI.Color(hex: 0x000000))

        // MARK: - Surfaces

        public static let surfacePrimary = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xFFFFFF), dark: SwiftUI.Color(hex: 0x000000))
        public static let surfacePrimaryHover = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xE5E5E5), dark: SwiftUI.Color(hex: 0x171717))
        public static let surfaceSecondary = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xA1A1A1), dark: SwiftUI.Color(hex: 0x262626))
        public static let surfaceSecondaryHover = SwiftUI.Color(hex: 0x737373) // mode-invariant per globals.css
        public static let surfaceTertiary = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xF5F5F5), dark: SwiftUI.Color(hex: 0x0A0A0A))
        public static let surfaceTertiaryHover = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xE5E5E5), dark: SwiftUI.Color(hex: 0x0A0A0A))
        public static let surfacePure = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0x000000), dark: SwiftUI.Color(hex: 0xFFFFFF))
        public static let surfaceBorderPrimary = SwiftUI.Color.modeAdaptive(light: SwiftUI.Color(hex: 0xE5E5E5), dark: SwiftUI.Color(hex: 0x404040))

        // MARK: - Status surfaces (semantic wrappers over brand colors)

        public static let statusInProgress = arkivBluePrimary
        public static let statusBacklog = purpleDrankPrimary
        public static let statusCompleted = goblinGreenPrimary
        public static let statusDeleted = ragebaitRedPrimary

        // MARK: - Status labels

        public static let statusLabelInProgress = textWhite
        public static let statusLabelInLibrary = textWhite
        public static let statusLabelBacklog = textWhite
        public static let statusLabelCompleted = goblinGreenSecondary
        public static let statusLabelDeleted = ragebaitRedSecondary

        // MARK: - Hover overlay (for vivid brand surfaces)

        /// The one permitted raw color value in the system — a black overlay used for
        /// hover on vivid brand surfaces (see Design Principle 4 in the arkiv skill).
        public static let hoverOverlay = SwiftUI.Color.black.opacity(0.4)
    }
}
