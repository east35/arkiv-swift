import XCTest
import SwiftUI
@testable import DesignSystem

final class ArkivTokensTests: XCTestCase {
    func testSpacingScaleIsMonotonic() {
        let scale: [CGFloat] = [
            ArkivSpacing.px2, ArkivSpacing.px4, ArkivSpacing.px6, ArkivSpacing.px8,
            ArkivSpacing.px10, ArkivSpacing.px12, ArkivSpacing.px16, ArkivSpacing.px20,
            ArkivSpacing.px24, ArkivSpacing.px28, ArkivSpacing.px32, ArkivSpacing.px40,
            ArkivSpacing.px48, ArkivSpacing.px56, ArkivSpacing.px64
        ]
        for (a, b) in zip(scale, scale.dropFirst()) {
            XCTAssertLessThan(a, b, "spacing scale must be strictly increasing")
        }
    }

    func testInteractionSizesMatchSpec() {
        XCTAssertEqual(ArkivSize.interactionMinHeight, 44)
        XCTAssertEqual(ArkivSize.tabNav, 56)
        XCTAssertEqual(ArkivSize.interactionInputMinWidth, 128)
        XCTAssertEqual(ArkivSize.interactionDesktopInputMinWidth, 160)
    }

    func testBrandColorsCompile() {
        // Guards that the brand token surface isn't accidentally removed.
        _ = ArkivColor.arkivBluePrimary
        _ = ArkivColor.ragebaitRedPrimary
        _ = ArkivColor.goblinGreenPrimary
        _ = ArkivColor.purpleDrankPrimary
    }
}
