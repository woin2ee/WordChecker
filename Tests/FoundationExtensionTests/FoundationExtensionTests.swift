@testable import FoundationExtension

import XCTest

final class FoundationExtensionTests: XCTestCase {

    func test_isNotEmpty() {
        // Given
        let string: String = ""

        // When
        let isNotEmpty = string.isNotEmpty

        // Then
        XCTAssertEqual(isNotEmpty, false)
    }

}
