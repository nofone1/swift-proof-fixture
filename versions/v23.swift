import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Swift Proof Fixture")
                .font(.largeTitle)
            Text("DOGFOOD MARKER v23")
                .font(.title2)
                .foregroundStyle(.primary)
            Text("Harness track UI marker — version v23")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
