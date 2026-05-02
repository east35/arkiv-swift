import XCTest
@testable import Core

final class AppConfigTests: XCTestCase {
    func testInitStoresValues() throws {
        let url = try XCTUnwrap(URL(string: "https://example.supabase.co"))
        let config = AppConfig(supabaseURL: url, supabaseAnonKey: "anon")
        XCTAssertEqual(config.supabaseURL, url)
        XCTAssertEqual(config.supabaseAnonKey, "anon")
    }
}
