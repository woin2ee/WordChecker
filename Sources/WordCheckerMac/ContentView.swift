import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Label("Hello", systemImage: "star")
            .padding()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
