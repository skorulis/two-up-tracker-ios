import SwiftUI

/// Preset bet amounts in a two-column grid; updates `amountText` when a value is chosen.
struct BetAmountGrid: View {
    static let presetAmounts: [Double] = [5, 10, 20, 40, 50, 100]

    @Binding var amountText: String

    private let columns = [
        GridItem(.flexible(), spacing: DesignTokens.Spacing.sm),
        GridItem(.flexible(), spacing: DesignTokens.Spacing.sm),
    ]

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "AUD"
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.sm) {
            ForEach(Self.presetAmounts, id: \.self) { amount in
                let selected = isSelected(amount)
                Button {
                    amountText = String(Int(amount))
                } label: {
                    Text(amount, format: .currency(code: currencyCode))
                        .font(DesignTokens.Typography.body.monospacedDigit())
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: DesignTokens.MinTapTarget.height)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.chip, style: .continuous)
                        .fill(selected ? Color.accentColor.opacity(0.18) : Colors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.chip, style: .continuous)
                        .strokeBorder(selected ? Color.accentColor : Color.secondary.opacity(0.35), lineWidth: selected ? 2 : 1)
                )
                .foregroundStyle(selected ? Color.accentColor : .primary)
                .accessibilityLabel("Bet amount \(Int(amount))")
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Quick amount")
    }

    private func isSelected(_ amount: Double) -> Bool {
        let trimmed = amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Double(trimmed) else { return false }
        return abs(value - amount) < 0.000_000_1
    }
}

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
