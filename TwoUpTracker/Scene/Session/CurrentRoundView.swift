import ASKCoordinator
import SwiftUI

struct CurrentRoundView: View {
    @State var viewModel: CurrentRoundViewModel

    private var currencyCode: String { "AUD" }

    /// Whole dollars without “.00”; cents shown when needed (e.g. $10.50).
    private var currencyDisplayFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: currencyCode).precision(.fractionLength(0...2))
    }

    var body: some View {
        if viewModel.model.bettingAvailable {
            mainContent
        } else {
            countdownDisplay
        }
    }

    private var mainContent: some View {
        PageLayout {
            PageHeader(title: viewModel.model.session.name)
        } content: {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.medium) {
                    if let pending = viewModel.model.pendingRoundAwaitingResult {
                        pendingTossContent(for: pending)

                        Button("Reset") {
                            viewModel.resetForm()
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Clear bet fields")
                    } else {
                        Card {
                            AddBetView(
                                onSetBet: { viewModel.saveRound(bet: $0) }
                            )
                        }
                    }
                }
                .padding(.bottom, DesignTokens.Spacing.medium)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var countdownDisplay: some View {
        PageLayout {
            PageHeader(title: viewModel.model.session.name)
        } content: {
            VStack(spacing: DesignTokens.Spacing.medium) {
                Spacer()
                CountdownTimer(
                    session: viewModel.model.session,
                    onInfoTapped: { viewModel.showTwoUpAvailabilityInfo() }
                )

                Button("start betting") {
                    viewModel.model.bettingAvailable = true
                }
                .buttonStyle(.primary)
                .frame(maxWidth: .infinity)

                Button("What is Two-Up?") {
                    viewModel.showWhatIsTwoUp()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)

                Spacer()
            }
        }
    }

    @ViewBuilder
    private func pendingTossContent(for round: Round) -> some View {
        VStack(spacing: DesignTokens.Spacing.medium) {
            Card {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(round.totalStaked, format: currencyDisplayFormat)
                        .font(DesignTokens.Typography.title.monospacedDigit())
                        .accessibilityLabel("Total staked")

                    Text("Total staked")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                .accessibilityElement(children: .combine)
            }

            bets(round: round)

            Card {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                    Text("What is the result")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)

                    CoinOutcomeRow(selectedOutcome: $viewModel.model.pendingResultSelection)

                    Button("Confirm") {
                        guard let outcome = viewModel.model.pendingResultSelection else { return }
                        viewModel.recordPendingOutcome(outcome)
                        viewModel.model.pendingResultSelection = nil
                    }
                    .buttonStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.model.pendingResultSelection == nil)
                    .accessibilityLabel("Confirm toss result")
                }
            }
        }
    }

    private func bets(round: Round) -> some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                Text("Round \(viewModel.model.session.rounds.count) bets")
                    .font(DesignTokens.Typography.headline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 0) {
                    ForEach(Array(round.bets.enumerated()), id: \.element.id) { index, bet in
                        betRow(bet)
                        if index < round.bets.count - 1 {
                            Divider()
                                .padding(.vertical, DesignTokens.Spacing.xs)
                        }
                    }
                }

                Button(action: viewModel.addAnotherBet) {
                    HStack {
                        Spacer()
                        Text("Add another bet to this round")
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
    }

    private func betRow(_ bet: Bet) -> some View {
        HStack {
            Text(bet.prediction.rawValue.capitalized)
                .font(DesignTokens.Typography.body)
            Spacer()
            Text(bet.amount, format: currencyDisplayFormat)
                .font(DesignTokens.Typography.body.monospacedDigit())
        }
        .accessibilityElement(children: .combine)
    }

}

extension CurrentRoundView {
    struct Model {
        var session: Session = .defaultSession()
        var bettingAvailable: Bool = false
        var pendingResultSelection: Outcome?

        /// Most recent round that still needs a toss result, if any.
        var pendingRoundAwaitingResult: Round? {
            session.roundsOrdered
                .filter { $0.result == nil }
                .max(by: { $0.startDate < $1.startDate })
        }
    }
}
