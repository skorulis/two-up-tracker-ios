import SwiftUI

/// Full-width hero block on the grouped background (no card chrome): large staked amount plus caption.
struct LargeValuedHeroView: View {
    let amount: Double
    let format: FloatingPointFormatStyle<Double>.Currency
    let caption: String = "On the line"

    var body: some View {
        VStack(spacing: 0) {
            Text(amount, format: format)
                .font(DesignTokens.Typography.heroValue.monospacedDigit())
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.55)
                .lineLimit(1)

            Text(caption)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, DesignTokens.Spacing.small)
        .padding(.bottom, DesignTokens.Spacing.large)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    LargeValuedHeroView(
        amount: 92.50,
        format: .currency(code: "AUD").precision(.fractionLength(0...2))
    )
}
