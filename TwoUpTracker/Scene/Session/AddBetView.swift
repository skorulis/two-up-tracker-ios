import SwiftUI

struct AddBetView: View {
    @State var draft = BetDraft(id: UUID(), amountText: "", prediction: .heads)
    let onSetBet: (Bet) -> Void

    var body: some View {
        Group {
            Section {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                    Picker("Prediction", selection: $draft.prediction) {
                        ForEach(Outcome.allCases, id: \.self) { outcome in
                            Text(outcome.rawValue.capitalized).tag(outcome)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(minWidth: 160)
                    
                    BetAmountGrid(amountText: $draft.amountText)
                    HStack {
                        TextField("Amount", text: $draft.amountText)
                            .keyboardType(.decimalPad)
                            .font(DesignTokens.Typography.body.monospacedDigit())
                    }
                    Button("Set Bet") {
                        if let bet {
                            onSetBet(bet)
                        }
                    }
                    .buttonStyle(.primary)
                    .disabled(bet == nil)
                }
            }
        }
    }

    var bet: Bet? {
        let trimmed = draft.amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Double(trimmed), value > 0 else { return nil }
        return Bet(id: draft.id, amount: value, prediction: draft.prediction)
    }
}
