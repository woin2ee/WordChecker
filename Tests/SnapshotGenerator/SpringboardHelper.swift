import XCTest

final class SpringboardHelper {
    private static var keyboardDismissed = false

    /// Call this from the setUp() function of any UI test that deals with the keyboard.
    static func showKeyboardIfNeeded() {
        if !keyboardDismissed {
            let springBoard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
            springBoard.activate()
            springBoard.windows.firstMatch.swipeDown(velocity: .slow)
//            springBoard.windows.firstMatch.tap()
            springBoard.windows.firstMatch.swipeUp(velocity: .slow)

            keyboardDismissed = true
        }
    }
}
