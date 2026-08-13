import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Swift Proof Fixture")
                .font(.largeTitle)
            Text("DOGFOOD MARKER v21")
                .font(.title2)
                .foregroundStyle(.primary)
            Text("Harness track UI marker — version v21")
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
