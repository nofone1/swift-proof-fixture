import SwiftUI

struct ContentView: View {
    private enum Screen {
        case home
        case details
        case preferences
    }

    @AppStorage("swift_minimal_note") private var note = "Edit this note, rebuild, then relaunch."
    @AppStorage("swift_minimal_keep_loop_visible") private var keepLoopVisible = true
    @AppStorage("swift_minimal_daily_summary") private var dailySummaryEnabled = false
    @AppStorage("swift_minimal_reminder_hour") private var reminderHour = 9
    @State private var screen: Screen = .home
    @State private var draftDailySummaryEnabled = false
    @State private var draftReminderHour = 9
    @State private var preferencesSaved = false

    private var screenTitle: String {
        switch screen {
        case .home:
            return "swift-minimal"
        case .details:
            return "Details"
        case .preferences:
            return "Preferences"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Xcode / SwiftUI")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundStyle(Color(red: 0.43, green: 0.35, blue: 0.22))

                Text(screenTitle)
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

                        Text("Edit the note, flip the persisted toggle, then relaunch the simulator to confirm UserDefaults kept everything.")
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

                        Button("Notification preferences") {
                            draftDailySummaryEnabled = dailySummaryEnabled
                            draftReminderHour = reminderHour
                            preferencesSaved = false
                            screen = .preferences
                        }
                        .buttonStyle(.bordered)
                    }
                } else if screen == .details {
                    infoCard {
                        Text("Details")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Second screen in the shared dogfood contract.")
                            .foregroundStyle(.secondary)

                        detailRow(label: "Saved note", value: note)
                        detailRow(label: "Saved toggle", value: keepLoopVisible ? "On across relaunches" : "Off across relaunches")
                        detailRow(label: "Daily summary", value: dailySummaryEnabled ? "Enabled" : "Disabled")
                        detailRow(label: "Reminder time", value: "\(reminderHour):00")
                        detailRow(label: "Journey", value: "Init -> dev -> edit -> rebuild -> relaunch -> confirm state")

                        Button("Back home") {
                            screen = .home
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    infoCard {
                        Text("Notifications")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Choose when the fixture should summarize completed rebuilds.")
                            .foregroundStyle(.secondary)

                        Toggle("Send a daily summary", isOn: $draftDailySummaryEnabled)

                        Picker("Reminder time", selection: $draftReminderHour) {
                            Text("9 AM").tag(9)
                            Text("1 PM").tag(13)
                            Text("5 PM").tag(17)
                        }
                        .pickerStyle(.segmented)

                        Button("Save preferences") {
                            dailySummaryEnabled = draftDailySummaryEnabled
                            preferencesSaved = true
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("save-preferences-button")

                        if preferencesSaved {
                            Text("Preferences saved for \(draftReminderHour):00")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(red: 0.17, green: 0.37, blue: 0.34))
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
