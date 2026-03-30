import ASKCoordinator
import SwiftUI

struct CurrentRoundView: View {
    @State var viewModel: AddRoundViewModel

    private var currencyCode: String { "AUD" }

    /// Whole dollars without “.00”; cents shown when needed (e.g. $10.50).
    private var currencyDisplayFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: currencyCode).precision(.fractionLength(0...2))
    }

    var body: some View {
        Form {
            if let pending = viewModel.model.pendingRoundAwaitingResult {
                pendingTossSection(for: pending)

                Button("Reset") {
                    viewModel.resetForm()
                }
                .accessibilityLabel("Clear bet fields")
            } else {
                AddBetView(
                    onSetBet: { viewModel.saveRound(bet: $0) }
                )
            }
        }
    }

    @ViewBuilder
    private func pendingTossSection(for round: Round) -> some View {
        Section {
            HStack {
                Text("Round time")
                    .font(DesignTokens.Typography.body)
                Spacer()
                Text(round.date, format: .dateTime.day().month().year().hour().minute())
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Total staked")
                    .font(DesignTokens.Typography.headline)
                Spacer()
                Text(round.totalStaked, format: currencyDisplayFormat)
                    .font(DesignTokens.Typography.statValue.monospacedDigit())
            }
            .accessibilityElement(children: .combine)
        }

        Section {
            ForEach(round.bets) { bet in
                HStack {
                    Text(bet.prediction.rawValue.capitalized)
                        .font(DesignTokens.Typography.body)
                    Spacer()
                    Text(bet.amount, format: currencyDisplayFormat)
                        .font(DesignTokens.Typography.body.monospacedDigit())
                }
                .accessibilityElement(children: .combine)
            }
        } header: {
            Text("Your bets")
        }

        Section {
            HStack(spacing: DesignTokens.Spacing.medium) {
                Text("Toss")
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                Spacer()

                CoinOutcomeButton(outcome: .heads) {
                    viewModel.recordPendingOutcome(.heads)
                }
                CoinOutcomeButton(outcome: .tails) {
                    viewModel.recordPendingOutcome(.tails)
                }
            }
            .accessibilityElement(children: .contain)
        } footer: {
            Text("Choose the coin toss result to update your P&L for this round.")
                .font(DesignTokens.Typography.caption)
        }
    }

}

struct BetDraft: Identifiable, Equatable {
    let id: UUID
    var amountText: String
    var prediction: Outcome
}

extension CurrentRoundView {
    struct Model {
        var betDrafts: [BetDraft] = [BetDraft(id: UUID(), amountText: "", prediction: .heads)]
        var session: Session = .defaultSession()

        /// Most recent round that still needs a toss result, if any.
        var pendingRoundAwaitingResult: Round? {
            session.roundsOrdered
                .filter { $0.result == nil }
                .max(by: { $0.date < $1.date })
        }
    }
}
