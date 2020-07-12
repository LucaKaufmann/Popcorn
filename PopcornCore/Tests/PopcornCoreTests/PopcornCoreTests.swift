import XCTest
@testable import PopcornCore

final class PopcornCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PopcornCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
