import SwiftUI

struct ContentView: View {
    private enum Screen {
        case home
        case details
    }

    @AppStorage("swift_minimal_note") private var note = "Edit this note, rebuild, then relaunch."
    @AppStorage("swift_minimal_keep_loop_visible") private var keepLoopVisible = true
    @AppStorage("swift_minimal_daily_summary") private var dailySummaryEnabled = true
    @AppStorage("swift_minimal_summary_hour") private var savedSummaryHour = 9
    @State private var draftSummaryHour = 9
    @State private var screen: Screen = .home

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Xcode / SwiftUI")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundStyle(Color(red: 0.43, green: 0.35, blue: 0.22))

                Text(screen == .home ? "swift-minimal" : "Details")
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
                    }

                    infoCard {
                        Text("Notification summary")
                            .font(.system(size: 22, weight: .bold, design: .rounded))

                        Text("Choose when the daily rebuild summary should arrive.")
                            .foregroundStyle(.secondary)

                        Toggle("Daily summary", isOn: $dailySummaryEnabled)

                        Picker("Delivery time", selection: $draftSummaryHour) {
                            Text("9:00 AM").tag(9)
                            Text("1:00 PM").tag(13)
                            Text("5:00 PM").tag(17)
                        }
                        .pickerStyle(.segmented)
                        .disabled(!dailySummaryEnabled)
                        .onAppear {
                            draftSummaryHour = savedSummaryHour
                        }

                        Button("Save schedule") {
                            savedSummaryHour = draftSummaryHour
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!dailySummaryEnabled)

                        Text("Saved delivery: \(formattedHour(savedSummaryHour))")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
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

    private func formattedHour(_ hour: Int) -> String {
        switch hour {
        case 13:
            return "1:00 PM"
        case 17:
            return "5:00 PM"
        default:
            return "9:00 AM"
        }
    }
}
