import SwiftUI

/// Explains when Two-Up is available to play (noon to sunset on 25 April).
struct TwoUpAvailabilityInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
            SectionHeader(title: "When is Two-Up available?")

            Text(
                "Two up can be played between noon (12:00pm) and sunset on 25 April (Anzac Day)."
            )
            .font(DesignTokens.Typography.body)

            Text(
                "Sunset varies by location."
            )
            .font(DesignTokens.Typography.caption)
            .foregroundStyle(.secondary)
        }
    }
}

