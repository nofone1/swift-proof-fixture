import SwiftUI

struct ContentView: View {
    private enum Screen {
        case dashboard
        case checklist
        case schedule
    }

    private let checklistItems = [
        "Verify App Store metadata",
        "Confirm staged rollout audience",
        "Review support handoff"
    ]

    @State private var screen: Screen = .dashboard
    @State private var completedItems: Set<String> = []
    @State private var selectedSummaryTime = "5:00 PM"
    @State private var isApproved = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                switch screen {
                case .dashboard:
                    dashboard
                case .checklist:
                    checklist
                case .schedule:
                    schedule
                }
            }
            .padding(24)
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("RELEASE CONTROL")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Color.indigo)

            Text(screenTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("Coordinate the final checks, approval, and customer communication for the next build.")
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    private var dashboard: some View {
        VStack(alignment: .leading, spacing: 16) {
            infoCard {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("iOS 4.8.0")
                            .font(.system(size: 23, weight: .bold, design: .rounded))
                        Text("Candidate 1842")
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(isApproved ? "Approved" : "Awaiting approval")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(isApproved ? Color.green.opacity(0.16) : Color.orange.opacity(0.16))
                        .clipShape(Capsule())
                }

                Divider()

                detailRow(label: "Checklist", value: "\(completedItems.count) of \(checklistItems.count) complete")
                detailRow(label: "Customer summary", value: "Today at \(selectedSummaryTime)")
            }

            HStack(spacing: 12) {
                navigationButton("Review checklist", destination: .checklist)
                navigationButton("Summary schedule", destination: .schedule)
            }

            infoCard {
                Text("Final approval")
                    .font(.system(size: 21, weight: .bold, design: .rounded))

                Text("Approve once the checklist and rollout timing are ready.")
                    .foregroundStyle(.secondary)

                Button("Approve release") {
                    isApproved = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var checklist: some View {
        infoCard {
            Text("Launch checklist")
                .font(.system(size: 22, weight: .bold, design: .rounded))

            Text("Complete each handoff before approving the release.")
                .foregroundStyle(.secondary)

            ForEach(checklistItems, id: \.self) { item in
                Button {
                    if completedItems.contains(item) {
                        completedItems.remove(item)
                    } else {
                        completedItems.insert(item)
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: completedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(completedItems.contains(item) ? Color.green : Color.secondary)
                        Text(item)
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
            }

            Button("Back to release") {
                screen = .dashboard
            }
            .buttonStyle(.bordered)
        }
    }

    private var schedule: some View {
        VStack(alignment: .leading, spacing: 16) {
            infoCard {
                Text("Customer summary")
                    .font(.system(size: 22, weight: .bold, design: .rounded))

                Text("Choose when customers receive the release summary.")
                    .foregroundStyle(.secondary)

                Picker("Delivery time", selection: $selectedSummaryTime) {
                    Text("9:00 AM").tag("9:00 AM")
                    Text("1:00 PM").tag("1:00 PM")
                    Text("5:00 PM").tag("5:00 PM")
                }
                .pickerStyle(.segmented)

                Text("Scheduled for today at \(selectedSummaryTime)")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }

            Text("The customer-facing summary will include rollout progress and support contact details.")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.45))
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.95, green: 0.72, blue: 0.20))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Button("Back to release") {
                screen = .dashboard
            }
            .buttonStyle(.bordered)
        }
    }

    private var screenTitle: String {
        switch screen {
        case .dashboard:
            "Release readiness"
        case .checklist:
            "Preflight checklist"
        case .schedule:
            "Notification window"
        }
    }

    private func navigationButton(_ title: String, destination: Screen) -> some View {
        Button(title) {
            screen = destination
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
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
                .font(.system(size: 16, design: .rounded))
        }
    }
}
