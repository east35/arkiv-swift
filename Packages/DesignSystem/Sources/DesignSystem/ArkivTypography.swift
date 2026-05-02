import SwiftUI

/// Arkiv typography tokens — ported from the 14 Figma text styles in `src/globals.css`.
///
/// The web token triplet (`--text-{style}-size`, `--text-{style}-weight`, `--text-{style}-lh`)
/// maps to a single SwiftUI `Font` per style. Line-height is not expressible on `Font`
/// alone in SwiftUI — apply it at call sites with `.lineSpacing(ArkivLineHeight.<style>)`
/// when pixel parity matters.
///
/// Values below are the current arkiv system defaults. If you change them here,
/// also update `src/globals.css` to stay in sync.
public enum ArkivTypography {
    // Headings
    public static let heading1 = Font.system(size: 32, weight: .bold)
    public static let heading2 = Font.system(size: 28, weight: .bold)
    public static let heading3 = Font.system(size: 24, weight: .semibold)
    public static let heading4 = Font.system(size: 20, weight: .semibold)
    public static let heading5 = Font.system(size: 16, weight: .semibold)
    /// 14 / 700 — used inside buttons.
    public static let heading6 = Font.system(size: 14, weight: .bold)

    // Body
    public static let bodyPrimary = Font.system(size: 15, weight: .regular)
    public static let bodySecondary = Font.system(size: 13, weight: .regular)
    public static let bodyLabel = Font.system(size: 13, weight: .regular)

    // Interactive
    public static let interactiveNavDesktop = Font.system(size: 14, weight: .medium)
    public static let interactiveNavMobile = Font.system(size: 12, weight: .medium)
    public static let interactiveStatusLabel = Font.system(size: 13, weight: .semibold)

    // Item preview
    public static let itemPreviewTitle = Font.system(size: 14, weight: .semibold)
    public static let itemPreviewMetadata = Font.system(size: 12, weight: .regular)
}
