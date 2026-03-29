import SwiftUI

/// Currency text with semantic coloring for profit, loss, and zero (PRD: large numbers as currency; negative clearly red).
struct CurrencyLabel: View {
    let amount: Double
    var locale: Locale = .current

    private var isWholeNumber: Bool {
        abs(amount - amount.rounded()) < 1e-9
    }

    private var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        if isWholeNumber {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        }
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }

    private var semanticColor: Color {
        if amount > 0 {
            Colors.profit
        } else if amount < 0 {
            Colors.loss
        } else {
            Colors.neutral
        }
    }

    var body: some View {
        Text(formatted)
            .font(DesignTokens.Typography.statValue)
            .foregroundStyle(semanticColor)
    }
}

#Preview {
    VStack {
        CurrencyLabel(amount: 125.50)
        CurrencyLabel(amount: -33)
        CurrencyLabel(amount: 0)
        CurrencyLabel(amount: 200)
        CurrencyLabel(amount: -47.25)
    }
    
}
