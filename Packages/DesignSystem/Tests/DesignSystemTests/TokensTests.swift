import XCTest
import SwiftUI
@testable import DesignSystem

final class TokensTests: XCTestCase {
    func testSpacingScaleIsMonotonic() {
        let scale: [CGFloat] = [
            Tokens.Spacing.px2, Tokens.Spacing.px4, Tokens.Spacing.px6, Tokens.Spacing.px8,
            Tokens.Spacing.px10, Tokens.Spacing.px12, Tokens.Spacing.px16, Tokens.Spacing.px20,
            Tokens.Spacing.px24, Tokens.Spacing.px28, Tokens.Spacing.px32, Tokens.Spacing.px40,
            Tokens.Spacing.px48, Tokens.Spacing.px56, Tokens.Spacing.px64
        ]
        for (a, b) in zip(scale, scale.dropFirst()) {
            XCTAssertLessThan(a, b, "spacing scale must be strictly increasing")
        }
    }

    func testInteractionSizesMatchSpec() {
        XCTAssertEqual(Tokens.Size.interactionMinHeight, 44)
        XCTAssertEqual(Tokens.Size.tabNav, 56)
        XCTAssertEqual(Tokens.Size.interactionInputMinWidth, 128)
        XCTAssertEqual(Tokens.Size.interactionDesktopInputMinWidth, 160)
    }

    func testBrandColorsCompile() {
        // Guards that the brand token surface isn't accidentally removed.
        _ = Tokens.Color.arkivBluePrimary
        _ = Tokens.Color.ragebaitRedPrimary
        _ = Tokens.Color.goblinGreenPrimary
        _ = Tokens.Color.purpleDrankPrimary
    }
}
