import SwiftUI

struct LossLimitBanner: View {
    enum State {
        case approaching
        case nextBet(Double)
        case exceeded
    }

    let state: State
    let currentLoss: Double
    let lossLimit: Double

    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.small) {
            Image(systemName: iconName)
                .foregroundStyle(accentColor)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(title)
                    .font(DesignTokens.Typography.bodyStrong)
                Text(detail)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(DesignTokens.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.card, style: .continuous))
        .skip_accessibilityElement(children: .combine)
    }

    private var title: String {
        switch state {
        case .approaching, .nextBet:
            return "Approaching loss limit"
        case .exceeded:
            return "Loss limit exceeded"
        }
    }

    private var detail: String {
        let formattedCurrentLoss = currentLoss.formatted(Formatters.currencyDisplayFormat)
        let formattedLimit = lossLimit.formatted(Formatters.currencyDisplayFormat)
        switch state {
        case .approaching:
            return "You are at \(formattedCurrentLoss) of your \(formattedLimit) loss limit."
        case let .nextBet(amount):
            let formattedBet = amount.formatted(Formatters.currencyDisplayFormat)
            return "A loss of \(formattedBet) would put you over your \(formattedLimit) loss limit."
        case .exceeded:
            return "You have gone over your \(formattedLimit) loss limit."
        }
    }

    private var iconName: String {
        switch state {
        case .approaching, .nextBet:
            return "exclamationmark.triangle.fill"
        case .exceeded:
            return "xmark.octagon.fill"
        }
    }

    private var accentColor: Color {
        switch state {
        case .approaching, .nextBet:
            return .orange
        case .exceeded:
            return Colors.loss
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .approaching, .nextBet:
            return Color.orange.opacity(0.14)
        case .exceeded:
            return Colors.loss.opacity(0.12)
        }
    }
}

struct LossLimitBannerModel {
    let state: LossLimitBanner.State
    let currentLoss: Double
    let lossLimit: Double
}

#if !os(Android)
#Preview("Next Bet") {
    LossLimitBanner(state: .nextBet(40), currentLoss: 80, lossLimit: 100)
        .padding()
        .background(Colors.groupedBackground)
}

#Preview("Exceeded") {
    LossLimitBanner(state: .exceeded, currentLoss: 130, lossLimit: 100)
        .padding()
        .background(Colors.groupedBackground)
}
#endif
