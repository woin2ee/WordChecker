@testable import IOSScene_ThemeSetting

import XCTest

final class ThemeSettingTests: XCTestCase {

    var sut: ThemeSettingReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_example() {
        // Given

        // When

        // Then
        XCTAssertEqual("ThemeSettingKit", "ThemeSettingKit")
    }

}
