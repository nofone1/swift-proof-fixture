import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.94, blue: 0.90)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                Text("Sign in required")
                    .font(.system(size: 34, weight: .bold, design: .rounded))

                Text("This preview needs an account before the changed home screen can be observed.")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundStyle(.secondary)

                Text("No test account is available in this proof run.")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Button("Continue with account") {}
                    .buttonStyle(.borderedProminent)
                    .disabled(true)
            }
            .padding(28)
        }
    }
}
