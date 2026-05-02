import SwiftUI

#if canImport(UIKit)
import UIKit
public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias PlatformColor = NSColor
#endif

public extension Color {
    /// Initialize a `Color` from a hex RGB integer (e.g. `0x1F19F6`).
    init(hex: UInt32, opacity: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }

    /// Build a mode-adaptive color that resolves to `light` in light mode and `dark` in dark mode.
    ///
    /// Prefer this over `@Environment(\.colorScheme)` branching for token-level color definitions;
    /// it means any view — including those outside SwiftUI's environment — gets the right value.
    static func modeAdaptive(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #elseif canImport(AppKit)
        return Color(NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .vibrantDark, .aqua]) == .darkAqua
                || appearance.bestMatch(from: [.darkAqua, .vibrantDark, .aqua]) == .vibrantDark
            return isDark ? NSColor(dark) : NSColor(light)
        })
        #else
        return light
        #endif
    }
}
