import SwiftUI

@main
struct WordCheckerMac: App {

    @NSApplicationDelegateAdaptor
    private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup("Title") {
            ContentView()
                .frame(width: 200, height: 200)
        }
        .windowResizability(.contentSize)
    }
}
