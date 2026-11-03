import SwiftUI

struct ContentView: View {
    private enum Screen {
        case home
        case details
        case signIn
    }

    @AppStorage("swift_minimal_note") private var note = "Edit this note, rebuild, then relaunch."
    @AppStorage("swift_minimal_keep_loop_visible") private var keepLoopVisible = true
    @AppStorage("swift_minimal_sync_session") private var syncSession = ""
    @AppStorage("swift_minimal_last_synced") private var lastSynced = ""
    @State private var screen: Screen = .home
    @State private var email = ""
    @State private var password = ""
    @State private var signInError: String?
    @State private var isSigningIn = false

    private static let syncSessionURL = URL(string: "https://sync.swift-minimal.invalid/api/session")!

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Xcode / SwiftUI")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundStyle(Color(red: 0.43, green: 0.35, blue: 0.22))

                Text(title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))

                Text("Tiny rebuild-first sample for dogfooding onboarding, navigation, and relaunch persistence.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)

                infoCard {
                    detailRow(label: "Sample", value: "swift-minimal")
                    detailRow(label: "Build system", value: "Xcode")
                    detailRow(label: "Platform", value: "iOS Simulator")
                    detailRow(label: "Build marker", value: "swift-minimal@1.0")
                }

                if screen == .home {
                    infoCard {
                        Text("Home")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Edit the, flip the persisted toggle, then relaunch the simulator to confirm UserDefaults kept everything.")
                            .foregroundStyle(.secondary)

                        TextField("Persistent note", text: $note, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(4, reservesSpace: true)

                        Toggle("Keep rebuild loop visible", isOn: $keepLoopVisible)

                        Text("Relaunch-proof check: saved locally in UserDefaults.")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(red: 0.17, green: 0.37, blue: 0.34))

                        Button("Open details") {
                            screen = .details
                        }
                        .buttonStyle(.borderedProminent)

                        if syncSession.isEmpty {
                            Button("Sign in to sync") {
                                screen = .signIn
                            }
                            .buttonStyle(.bordered)
                        } else {
                            Text("Synced with cloud")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(red: 0.17, green: 0.37, blue: 0.34))
                        }
                    }
                } else if screen == .signIn {
                    infoCard {
                        Text("Sign in to sync")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Use your sync account to back up your note.")
                            .foregroundStyle(.secondary)

                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)

                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)

                        Button(isSigningIn ? "Signing in..." : "Sign in") {
                            Task { await signIn() }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(email.isEmpty || password.isEmpty || isSigningIn)

                        if let signInError {
                            Text(signInError)
                                .foregroundStyle(.red)
                        }

                        Button("Back home") {
                            screen = .home
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    infoCard {
                        Text("Details")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Second screen in the shared dogfood contract.")
                            .foregroundStyle(.secondary)

                        detailRow(label: "Saved note", value: note)
                        detailRow(label: "Saved toggle", value: keepLoopVisible ? "On across relaunches" : "Off across relaunches")
                        detailRow(label: "Journey", value: "Init -> dev -> edit -> rebuild -> relaunch -> confirm state")
                        if !syncSession.isEmpty {
                            detailRow(label: "Last synced", value: lastSynced)
                        }

                        Button("Back home") {
                            screen = .home
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding(24)
        }
        .background(Color(red: 0.96, green: 0.94, blue: 0.90))
    }

    private var title: String {
        switch screen {
        case .home:
            return "swift-minimal"
        case .details:
            return "Details"
        case .signIn:
            return "Sign in"
        }
    }

    private func signIn() async {
        isSigningIn = true
        defer { isSigningIn = false }
        var request = URLRequest(url: Self.syncSessionURL)
        request.httpMethod = "POST"
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["email": email, "password": password, "note": note])
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200,
                  let body = try? JSONDecoder().decode([String: String].self, from: data),
                  let session = body["session"] else {
                signInError = "Sign-in failed. Check your email and password."
                return
            }
            syncSession = session
            lastSynced = Date.now.formatted(date: .abbreviated, time: .shortened)
            signInError = nil
            screen = .home
        } catch {
            signInError = "Couldn't reach the sync server."
        }
    }

    @ViewBuilder
    private func infoCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(.primary)
        }
    }
}
