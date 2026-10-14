import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Chrome Hearts")
                    .font(.title)
                    .foregroundColor(.white)
                Text("❤️")
                    .font(.system(size: 60))
                Text("Los Angeles")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
