import ASKCoordinator
import Knit
import SwiftUI

struct CurrentRoundView: View {
    @State var viewModel: CurrentRoundViewModel

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
                    titleLine(round: viewModel.model.pendingRoundAwaitingResult)
                        .animation(.easeInOut, value: viewModel.model.session)

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
                Card {
                    CountdownTimer(
                        session: viewModel.model.session,
                        onInfoTapped: { viewModel.showTwoUpAvailabilityInfo() }
                    )

                    HStack {
                        Button("Start betting") {
                            viewModel.model.bettingAvailable = true
                        }
                        .buttonStyle(.primary)
                        .frame(maxWidth: .infinity)

                        Button("What is Two-Up?") {
                            viewModel.showWhatIsTwoUp()
                        }
                        .buttonStyle(.primary)
                        .frame(maxWidth: .infinity)
                    }
                }

                Spacer()
            }
        }
    }

    @ViewBuilder
    private func pendingTossContent(for round: Round) -> some View {
        VStack(spacing: DesignTokens.Spacing.medium) {

            bets(round: round)
            outcome(round: round)
        }
    }

    private func titleLine(round: Round?) -> some View {
        HStack {
            Spacer()
            LargeValuedHeroView(
                amount: viewModel.model.session.currentBalance,
                caption: "Daily position",
                colorAmountBySign: true,
            )
            if let round {
                Spacer()
                LargeValuedHeroView(amount: round.totalStaked, caption: "On the line")
            }
            Spacer()
        }
    }

    private func outcome(round: Round) -> some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
                Text("Spin result")
                    .font(DesignTokens.Typography.sectionTitle)

                HStack {
                    Spacer()
                    CoinOutcomeRow(selectedOutcome: $viewModel.model.pendingResultSelection)
                    Spacer()
                }

                Button {
                    guard let outcome = viewModel.model.pendingResultSelection else { return }
                    viewModel.recordPendingOutcome(outcome)
                    viewModel.model.pendingResultSelection = nil
                } label: {
                    Text(confirmButtonTitle(round: round, selection: viewModel.model.pendingResultSelection))
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        backgroundColor: confirmButtonBackground(
                            round: round,
                            selection: viewModel.model.pendingResultSelection,
                        )
                    )
                )
                .frame(maxWidth: .infinity)
                .disabled(viewModel.model.pendingResultSelection == nil)
                .accessibilityLabel(
                    confirmButtonTitle(round: round, selection: viewModel.model.pendingResultSelection)
                )
            }
        }
    }

    private func bets(round: Round) -> some View {
        Card {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                Text("Round \(viewModel.model.session.rounds.count) bets")
                    .font(DesignTokens.Typography.sectionTitle)

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
            Text(bet.amount, format: Formatters.currencyDisplayFormat)
                .font(DesignTokens.Typography.body.monospacedDigit())
        }
        .accessibilityElement(children: .combine)
    }

    private func confirmButtonTitle(round: Round, selection: Outcome?) -> String {
        guard let selection else { return "Confirm" }
        let net = round.netProfit(for: selection)
        if net > 0 {
            return "Confirm \(net.formatted(Formatters.currencyDisplayFormat)) win"
        }
        if net < 0 {
            return "Confirm \((-net).formatted(Formatters.currencyDisplayFormat)) loss"
        }
        return "Confirm even"
    }

    private func confirmButtonBackground(round: Round, selection: Outcome?) -> Color {
        guard let selection else { return Color.accentColor }
        let net = round.netProfit(for: selection)
        if net > 0 { return Colors.profit }
        if net < 0 { return Colors.loss }
        return Color.accentColor
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

// MARK: - Previews

private enum CurrentRoundPreviewSessions {
    static let baseDate = Date(timeIntervalSince1970: 1_745_462_400)

    static var bettingOpen: Session {
        Session(
            id: UUID(),
            name: "Anzac Day 2026",
            date: baseDate,
            year: 2026,
            rounds: []
        )
    }

    static var pendingToss: Session {
        Session(
            id: UUID(),
            name: "Anzac Day 2026",
            date: baseDate,
            year: 2026,
            rounds: [
                Round(
                    id: UUID(),
                    startDate: baseDate.addingTimeInterval(300),
                    endDate: nil,
                    result: nil,
                    bets: [
                        Bet(id: UUID(), amount: 50, prediction: .heads),
                        Bet(id: UUID(), amount: 30, prediction: .tails),
                        Bet(id: UUID(), amount: 12.50, prediction: .heads),
                    ]
                ),
            ]
        )
    }
}

#Preview("Countdown") {
    let assembler = TwoUpTrackerAssembly.testing()
    CurrentRoundView(viewModel: assembler.resolver.currentRoundViewModel())
}

#Preview("Add bet") {
    let assembler = TwoUpTrackerAssembly.testing()
    let viewModel = assembler.resolver.currentRoundViewModel()
    viewModel.mainStore.activeSession = CurrentRoundPreviewSessions.bettingOpen
    viewModel.model.bettingAvailable = true
    return CurrentRoundView(viewModel: viewModel)
}

#Preview("Pending toss") {
    let assembler = TwoUpTrackerAssembly.testing()
    let viewModel = assembler.resolver.currentRoundViewModel()
    viewModel.mainStore.activeSession = CurrentRoundPreviewSessions.pendingToss
    return CurrentRoundView(viewModel: viewModel)
}
