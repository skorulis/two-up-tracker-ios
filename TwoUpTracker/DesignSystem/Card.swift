import SwiftUI

/// Card container for stats and grouped content (PRD: cards for stats).
struct Card<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.card, style: .continuous))
    }
}

#Preview("Card") {
    Card {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Total profit")
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
            CurrencyLabel(amount: 128.40)
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Colors.groupedBackground)
}
