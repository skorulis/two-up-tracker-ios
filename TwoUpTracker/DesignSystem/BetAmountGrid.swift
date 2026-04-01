import SwiftUI

/// Preset bet amounts in a two-column grid; updates `amountText` when a value is chosen.
struct BetAmountGrid: View {
    static let presetAmounts: [Double] = [5, 10, 20, 40, 50, 100]

    private let color: Color = Colors.australianGold

    @Binding var amountText: String

    private let columns = [
        GridItem(.flexible(), spacing: DesignTokens.Spacing.small),
        GridItem(.flexible(), spacing: DesignTokens.Spacing.small),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.small) {
            ForEach(Self.presetAmounts, id: \.self) { amount in
                let selected = isSelected(amount)
                Button {
                    amountText = String(Int(amount))
                } label: {
                    Text(amount, format: Formatters.roundedCurrencyDisplayFormat)
                        .font(DesignTokens.Typography.buttonLabel.monospacedDigit())
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: DesignTokens.MinTapTarget.height)
                        .skip_contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.chip, style: .continuous)
                        .fill(selected ? color.opacity(0.18) : Colors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.chip, style: .continuous)
                        .strokeBorder(
                            selected ? color : Color.secondary.opacity(0.35),
                            lineWidth: selected ? 2 : 1
                        )
                )
                .foregroundStyle(.primary)
                .skip_accessibilityLabel("Bet amount \(Int(amount))")
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
        .skip_accessibilityElement(children: .contain)
        .skip_accessibilityLabel("Quick amount")
    }

    private func isSelected(_ amount: Double) -> Bool {
        let trimmed = amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Double(trimmed) else { return false }
        return abs(value - amount) < 0.000_000_1
    }
}

#if !os(Android)
#Preview("Bet amount grid") {
    @Previewable @State var text = ""
    VStack(alignment: .leading) {
        BetAmountGrid(amountText: $text)
        TextField("Amount", text: $text)
            .textFieldStyle(.roundedBorder)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(Colors.groupedBackground)
}
#endif
