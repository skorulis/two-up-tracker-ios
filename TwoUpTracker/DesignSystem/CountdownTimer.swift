import SwiftUI

/// Counts down to a fixed instant: **25 April, 12:00** in **Australia/Sydney** (legal Two-Up window on ANZAC Day).
struct CountdownTimer: View {
    let session: Session

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let now = context.date
            if session.bettingStartTime <= now {
               EmptyView()
            } else {
                timeRemaining(now: now)
            }
        }
    }

    private func timeRemaining(now: Date) -> some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            Text("Betting starts in")
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)

            Text(Self.formatRemaining(until: session.bettingStartTime, from: now))
                .font(countdownFont)
                .monospacedDigit()
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.45)
                .lineLimit(1)
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
    CountdownTimerPreviewSamples()
}

private struct CountdownTimerPreviewSamples: View {
    private static let soon = Date().addingTimeInterval(280_000)

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.large) {
            CountdownTimer(session: .defaultSession())
        }
        .padding()
    }
}
