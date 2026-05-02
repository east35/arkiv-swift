import CoreGraphics

/// Arkiv spacing tokens — ported from `src/globals.css`.
///
/// All padding, gaps, and inset distances should use one of these values. Never
/// hardcode a raw number at the call site.
public enum ArkivSpacing {
    public static let px2: CGFloat = 2
    public static let px4: CGFloat = 4
    public static let px6: CGFloat = 6
    public static let px8: CGFloat = 8
    public static let px10: CGFloat = 10
    public static let px12: CGFloat = 12
    public static let px16: CGFloat = 16
    public static let px20: CGFloat = 20
    public static let px24: CGFloat = 24
    public static let px28: CGFloat = 28
    public static let px32: CGFloat = 32
    public static let px40: CGFloat = 40
    public static let px48: CGFloat = 48
    public static let px56: CGFloat = 56
    public static let px64: CGFloat = 64
}

/// Arkiv interaction size tokens — ported from `src/globals.css`.
public enum ArkivSize {
    /// 44pt — desktop button / input height.
    public static let interactionMinHeight: CGFloat = 44
    /// 56pt — mobile button / tab height.
    public static let tabNav: CGFloat = 56
    /// 128pt — mobile input min width.
    public static let interactionInputMinWidth: CGFloat = 128
    /// 160pt — desktop input min width.
    public static let interactionDesktopInputMinWidth: CGFloat = 160
    /// 14pt — button label icons.
    public static let iconSm: CGFloat = 14
    /// 16pt — input icons.
    public static let iconMd: CGFloat = 16
}
