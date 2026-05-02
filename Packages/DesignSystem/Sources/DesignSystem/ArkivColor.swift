import SwiftUI

/// Arkiv color tokens.
///
/// Ported from `src/globals.css` in the web repo. Brand colors are mode-invariant;
/// surface / text tokens adapt between light and dark mode. No raw hex values should
/// ever be used at the call site — always reach for a token here.
///
/// Source of truth: `/Users/jimjordan/Development/arkiv/.claude/skills/arkiv-skill/SKILL.md`
/// and `src/globals.css`.
public enum ArkivColor {

    // MARK: - Grayscale primitives (mode-adaptive)

    public static let grayscale000 = Color.modeAdaptive(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x000000))
    public static let grayscale100 = Color.modeAdaptive(light: Color(hex: 0xE5E5E5), dark: Color(hex: 0x171717))
    public static let grayscale200 = Color.modeAdaptive(light: Color(hex: 0xA1A1A1), dark: Color(hex: 0x262626))
    public static let grayscale500 = Color.modeAdaptive(light: Color(hex: 0x2F2F2F), dark: Color(hex: 0x737373))
    public static let grayscale800 = Color.modeAdaptive(light: Color(hex: 0x171717), dark: Color(hex: 0xE5E5E5))
    public static let grayscale900 = Color.modeAdaptive(light: Color(hex: 0x0A0A0A), dark: Color(hex: 0xF5F5F5))
    public static let grayscale1000 = Color.modeAdaptive(light: Color(hex: 0x000000), dark: Color(hex: 0xFFFFFF))

    // MARK: - Brand (mode-invariant)

    public static let arkivBluePrimary = Color(hex: 0x1F19F6)
    public static let arkivBlueSecondary = Color(hex: 0x060531)

    public static let ragebaitRedPrimary = Color(hex: 0xFB2C36)
    public static let ragebaitRedSecondary = Color(hex: 0x330001)

    public static let goblinGreenPrimary = Color(hex: 0x04C950)
    public static let goblinGreenSecondary = Color(hex: 0x00210C)

    public static let purpleDrankPrimary = Color(hex: 0xAD46FF)
    public static let purpleDrankSecondary = Color(hex: 0x1E0332)

    // MARK: - Text

    public static let textPrimary = grayscale1000
    public static let textSecondary = Color.modeAdaptive(light: Color(hex: 0x737373), dark: Color(hex: 0xA1A1A1))
    public static let textTertiary = Color.modeAdaptive(light: Color(hex: 0xA1A1A1), dark: Color(hex: 0x262626))
    public static let textCritical = ragebaitRedPrimary
    public static let textWhite = Color(hex: 0xFFFFFF)
    public static let textPrimaryInverted = Color.modeAdaptive(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x000000))

    // MARK: - Surfaces

    public static let surfacePrimary = Color.modeAdaptive(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x000000))
    public static let surfacePrimaryHover = Color.modeAdaptive(light: Color(hex: 0xE5E5E5), dark: Color(hex: 0x171717))
    public static let surfaceSecondary = Color.modeAdaptive(light: Color(hex: 0xA1A1A1), dark: Color(hex: 0x262626))
    public static let surfaceSecondaryHover = Color(hex: 0x737373) // mode-invariant per globals.css
    public static let surfaceTertiary = Color.modeAdaptive(light: Color(hex: 0xF5F5F5), dark: Color(hex: 0x0A0A0A))
    public static let surfaceTertiaryHover = Color.modeAdaptive(light: Color(hex: 0xE5E5E5), dark: Color(hex: 0x0A0A0A))
    public static let surfacePure = Color.modeAdaptive(light: Color(hex: 0x000000), dark: Color(hex: 0xFFFFFF))
    public static let surfaceBorderPrimary = Color.modeAdaptive(light: Color(hex: 0xE5E5E5), dark: Color(hex: 0x404040))

    // MARK: - Status surfaces (semantic wrappers; mode-adaptive via the underlying brand color usage)

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

    /// The one permitted raw color value in the system — a black overlay used for hover
    /// on vivid brand surfaces (see Design Principle 4 in the arkiv skill).
    public static let hoverOverlay = Color.black.opacity(0.4)
}
