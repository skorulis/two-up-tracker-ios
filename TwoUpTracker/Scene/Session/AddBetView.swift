import ASKCore
import SwiftUI

struct AddBetView: View {
    @State var draft = BetDraft(id: UUID(), amountText: "", prediction: nil)
    @Binding var isCustomAmountFieldFocused: Bool
    @FocusState private var isCustomAmountFocused: Bool
    @Environment(\.dismissCustomOverlay) private var onDismiss
    let onSetBet: (Bet) -> Void

    var body: some View {
        Group {
            Section {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                    Text("What are you betting on?")
                        .font(DesignTokens.Typography.sectionTitle)
                    HStack(spacing: DesignTokens.Spacing.large) {
                        ForEach(Outcome.allCases, id: \.self) { outcome in
                            CoinOutcomeButton(
                                outcome: outcome,
                                borderColor: draft.prediction == outcome ? outcome.borderColor : .clear
                            ) {
                                draft.prediction = outcome
                            }
                            .accessibilityAddTraits(draft.prediction == outcome ? .isSelected : [])
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Text("How much?")
                        .font(DesignTokens.Typography.sectionTitle)

                    BetAmountGrid(amountText: $draft.amountText)
                    HStack {
                        TextField("Custom amount", text: $draft.amountText)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .font(DesignTokens.Typography.body.monospacedDigit())
                            .focused($isCustomAmountFocused)
                    }
                    Button("Track Bet") {
                        if let bet {
                            onSetBet(bet)
                            onDismiss()
                        }
                    }
                    .buttonStyle(
                        PrimaryButtonStyle(backgroundColor: bet == nil ? .accentColor : Colors.australianGreen)
                    )
                    .disabled(bet == nil)
                }
            }
        }
        .onAppear {
            isCustomAmountFocused = isCustomAmountFieldFocused
        }
        .onChange(of: isCustomAmountFocused) { focused in
            guard isCustomAmountFieldFocused != focused else { return }
            isCustomAmountFieldFocused = focused
        }
        .onChange(of: isCustomAmountFieldFocused) { focused in
            guard isCustomAmountFocused != focused else { return }
            isCustomAmountFocused = focused
        }
    }

    var bet: Bet? {
        let trimmed = draft.amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let prediction = draft.prediction else { return nil }
        guard let value = Double(trimmed), value >= 0 else { return nil }
        return Bet(id: draft.id, amount: value, prediction: prediction)
    }
}

struct BetDraft: Identifiable, Equatable {
    let id: UUID
    var amountText: String
    var prediction: Outcome?
}

#Preview {
    AddBetView(isCustomAmountFieldFocused: .constant(false), onSetBet: { _ in })
        .padding(DesignTokens.Spacing.large)
}
