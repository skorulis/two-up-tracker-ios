import SwiftUI

struct CountdownTimer: View {
    let session: Session
    var onInfoTapped: (() -> Void)?

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let now = context.date
            if session.bettingStartTime <= now {
               EmptyView()
            } else {
                VStack {
                    timeRemaining(now: now)
                    coins
                }

            }
        }
    }

    private var coins: some View {
        HStack {
            Spacer()
            SpinningCoinView()
            Spacer()
            SpinningCoinView(initialOffset: 180)
            Spacer()
        }
    }

    private func timeRemaining(now: Date) -> some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.medium) {
            VStack(spacing: DesignTokens.Spacing.small) {
                Text("Spinning starts in:")
                    .font(DesignTokens.Typography.bodyPrimary)
                    .foregroundStyle(.secondary)

                Text(Self.formatRemaining(until: session.bettingStartTime, from: now))
                    .font(countdownFont)
                    .monospacedDigit()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.45)
                    .lineLimit(1)
            }

            if let onInfoTapped {
                Button(action: onInfoTapped) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .accessibilityLabel("Two-Up availability info")
                }
                .buttonStyle(.plain)
                .padding(.top, 2)
                .accessibilityLabel("Two-Up availability info")
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var countdownFont: Font {
        .system(size: 44, weight: .semibold, design: .rounded)
    }

    /// Renders as `25d 04:03:12` (days plus HH:MM:SS) or `04:03:12` when under one day.
    static func formatRemaining(until target: Date, from now: Date) -> String {
        let interval = max(0, target.timeIntervalSince(now))
        let total = Int(interval.rounded(.down))
        let days = total / 86_400
        let hours = (total % 86_400) / 3_600
        let minutes = (total % 3_600) / 60
        let seconds = total % 60

        if days > 0 {
            return String(format: "%dd %02d:%02d:%02d", days, hours, minutes, seconds)
        }
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    VStack(spacing: DesignTokens.Spacing.large) {
        CountdownTimer(session: .defaultSession(), onInfoTapped: {})
    }
    .padding()
}
