import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Swift Proof Fixture")
                .font(.largeTitle)
            Text("DOGFOOD MARKER v5")
                .font(.title2)
                .foregroundStyle(.primary)
            Text("Harness track UI marker — version 5")
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
