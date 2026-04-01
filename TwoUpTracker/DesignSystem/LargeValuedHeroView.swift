import SwiftUI

/// Full-width hero block on the grouped background (no card chrome): large staked amount plus caption.
struct LargeValuedHeroView: View {
    let amount: Double
    let format: FloatingPointFormatStyle<Double>.Currency = Formatters.currencyDisplayFormat
    let caption: String
    /// When `true`, the value uses green for positive, red for negative, and neutral for zero (same semantics as ``CurrencyLabel``).
    var colorAmountBySign: Bool = false

    private var amountForegroundStyle: Color {
        if amount > 0 {
            Colors.profit
        } else if amount < 0 {
            Colors.loss
        } else {
            Colors.neutral
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(amount, format: format)
                .font(DesignTokens.Typography.heroValue.monospacedDigit())
                .foregroundStyle(colorAmountBySign ? amountForegroundStyle : .primary)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.55)
                .lineLimit(1)

            Text(caption)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, DesignTokens.Spacing.small)
        .padding(.bottom, DesignTokens.Spacing.large)
        .skip_accessibilityElement(children: .combine)
    }
}

extension LargeValuedHeroView {
    /// Caption for a running balance: **Win** when ahead, **Loss** when behind, **Balance** at zero.
    static func balanceCaption(for amount: Double) -> String {
        if amount > 0 {
            "Today's win"
        } else if amount < 0 {
            "Today's loss"
        } else {
            "Today's position"
        }
    }
}

#if !os(Android)
#Preview {
    VStack(spacing: DesignTokens.Spacing.large) {
        HStack {
            Spacer()
            LargeValuedHeroView(
                amount: -100,
                caption: LargeValuedHeroView.balanceCaption(for: -100),
                colorAmountBySign: true
            )
            Spacer()
            LargeValuedHeroView(amount: 92.50, caption: "On the line")
            Spacer()
        }
        HStack {
            Spacer()
            LargeValuedHeroView(
                amount: 42,
                caption: LargeValuedHeroView.balanceCaption(for: 42),
                colorAmountBySign: true
            )
            Spacer()
            LargeValuedHeroView(
                amount: 0,
                caption: LargeValuedHeroView.balanceCaption(for: 0),
                colorAmountBySign: true
            )
            Spacer()
        }
    }
}
#endif
