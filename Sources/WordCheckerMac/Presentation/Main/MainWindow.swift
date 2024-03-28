import AppKit

internal final class MainWindow: NSWindow {

    let mainViewController: MainViewController

    override var acceptsFirstResponder: Bool {
        true
    }

    init(mainViewController: MainViewController) {
        self.mainViewController = mainViewController
        super.init(
            contentRect: NSRect(),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: true
        )
        self.contentViewController = mainViewController
        self.isReleasedWhenClosed = false
    }
}
