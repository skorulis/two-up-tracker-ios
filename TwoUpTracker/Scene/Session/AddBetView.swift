import ASKCore
import SwiftUI

struct AddBetView: View {
    @State var draft = BetDraft(id: UUID(), amountText: "", prediction: .heads)
    @Environment(\.dismissCustomOverlay) private var onDismiss
    let onSetBet: (Bet) -> Void

    var body: some View {
        Group {
            Section {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                    Text("What are you betting on?")
                    HStack(spacing: DesignTokens.Spacing.large) {
                        ForEach(Outcome.allCases, id: \.self) { outcome in
                            CoinOutcomeButton(
                                outcome: outcome,
                                isSelected: draft.prediction == outcome
                            ) {
                                draft.prediction = outcome
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                    BetAmountGrid(amountText: $draft.amountText)
                    HStack {
                        TextField("Amount", text: $draft.amountText)
                            .keyboardType(.decimalPad)
                            .font(DesignTokens.Typography.body.monospacedDigit())
                    }
                    Button("Set Bet") {
                        if let bet {
                            onSetBet(bet)
                            onDismiss()
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
        guard let value = Double(trimmed), value >= 0 else { return nil }
        return Bet(id: draft.id, amount: value, prediction: draft.prediction)
    }
}
