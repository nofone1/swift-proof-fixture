import XCTest
@testable import SwiftMinimal

final class NoteLimitTests: XCTestCase {
    func testLimitMatchesOtherPlatforms() {
        XCTAssertEqual(ContentView.noteCharacterLimit, 60)
    }
}
