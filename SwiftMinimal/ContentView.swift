import SwiftUI

struct ContentView: View {
    private enum Screen {
        case overview
        case checklist
        case review
        case confirmation
    }

    @State private var screen: Screen = .overview
    @State private var smokeTestsPassed = false
    @State private var screenshotsReviewed = false
    @State private var rollbackOwnerAssigned = false

    private var completedCheckCount: Int {
        [smokeTestsPassed, screenshotsReviewed, rollbackOwnerAssigned]
            .filter { $0 }
            .count
    }

    private var screenTitle: String {
        switch screen {
        case .overview:
            return "Release readiness"
        case .checklist:
            return "Preflight checklist"
        case .review:
            return "Review launch"
        case .confirmation:
            return "Release launched"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                switch screen {
                case .overview:
                    overview
                case .checklist:
                    checklist
                case .review:
                    review
                case .confirmation:
                    confirmation
                }
            }
            .padding(24)
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("REVYL SHIP ROOM")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(Color.indigo)

            Text(screenTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("Move a candidate build through evidence review and launch approval.")
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    private var overview: some View {
        VStack(alignment: .leading, spacing: 18) {
            card {
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.indigo)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Candidate 1.4.0")
                            .font(.system(size: 20, weight: .bold, design: .rounded))

                        Text("iOS Simulator · Debug · commit 8c41e2a")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }

                Divider()

                detailRow(label: "Owner", value: "Mobile Platform")
                detailRow(label: "Target", value: "Internal beta")
                detailRow(label: "Checks", value: "\(completedCheckCount) of 3 complete")
            }

            Button("Start release check") {
                screen = .checklist
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityIdentifier("start-release-check-button")
        }
    }

    private var checklist: some View {
        VStack(alignment: .leading, spacing: 18) {
            card {
                Text("Required evidence")
                    .font(.system(size: 21, weight: .bold, design: .rounded))

                Text("Complete every item before moving to final review.")
                    .foregroundStyle(.secondary)

                Toggle("Smoke tests passed", isOn: $smokeTestsPassed)
                Toggle("Screenshots reviewed", isOn: $screenshotsReviewed)
                Toggle("Rollback owner assigned", isOn: $rollbackOwnerAssigned)

                HStack {
                    Text("Progress")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                    Spacer()
                    Text("\(completedCheckCount)/3")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                }

                ProgressView(value: Double(completedCheckCount), total: 3)
                    .tint(.indigo)
            }

            Button("Review release") {
                screen = .review
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityIdentifier("review-release-button")

            Button("Back to overview") {
                screen = .overview
            }
            .buttonStyle(.bordered)
        }
    }

    private var review: some View {
        VStack(alignment: .leading, spacing: 18) {
            card {
                Text("Launch summary")
                    .font(.system(size: 21, weight: .bold, design: .rounded))

                readinessRow(title: "Smoke tests", complete: smokeTestsPassed)
                readinessRow(title: "Visual review", complete: screenshotsReviewed)
                readinessRow(title: "Rollback owner", complete: rollbackOwnerAssigned)

                Divider()

                Text(
                    completedCheckCount == 3
                        ? "All release gates are complete."
                        : "\(3 - completedCheckCount) required gate(s) still need attention."
                )
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(completedCheckCount == 3 ? Color.green : Color.orange)
            }

            Button("Launch internal beta") {
                screen = .confirmation
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityIdentifier("launch-release-button")

            Button("Back to checklist") {
                screen = .checklist
            }
            .buttonStyle(.bordered)
        }
    }

    private var confirmation: some View {
        card {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 44))
                .foregroundStyle(.green)

            Text("Candidate 1.4.0 is live")
                .font(.system(size: 24, weight: .bold, design: .rounded))

            Text("The internal beta audience can now install this build.")
                .foregroundStyle(.secondary)

            detailRow(label: "Channel", value: "Internal beta")
            detailRow(label: "Evidence completed", value: "\(completedCheckCount) of 3")

            Button("Return to ship room") {
                screen = .overview
            }
            .buttonStyle(.bordered)
        }
    }

    private func readinessRow(title: String, complete: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: complete ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .foregroundStyle(complete ? Color.green : Color.orange)
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            Spacer()
            Text(complete ? "Ready" : "Missing")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.07), lineWidth: 1)
        )
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .multilineTextAlignment(.trailing)
        }
    }
}
