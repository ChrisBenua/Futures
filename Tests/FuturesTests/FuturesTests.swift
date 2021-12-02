import XCTest
@testable import Futures

final class FuturesTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Futures().text, "Hello, World!")
    }
}
