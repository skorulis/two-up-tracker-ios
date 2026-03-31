import SwiftUI

struct SessionDetailView: View {
    @State var viewModel: SessionDetailViewModel
    @State private var showResetConfirmation: Bool = false

    var body: some View {
        PageLayout {
            PageHeader(title: viewModel.model.sessionName)
        } content: {
            VStack(spacing: 0) {

                if viewModel.model.hasRounds {
                    listContent
                } else {
                    EmptyState(
                        title: "No rounds yet",
                        message: "Use the Add tab to enter your outstanding bets, then record the toss outcome " +
                            "here when you know it.",
                        systemImage: "list.bullet.rectangle"
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .id(viewModel.mainStore.activeSession.rounds.count)
        .navigationBarHidden(true)
        .alert("Reset all data?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                viewModel.resetSessionData()
            }
        } message: {
            Text("This will delete all of your bets.")
        }
    }

    private var listContent: some View {
        List {
            HStack {
                Spacer()
                LargeValuedHeroView(
                    amount: viewModel.model.currentBalance,
                    caption: LargeValuedHeroView.balanceCaption(for: viewModel.model.currentBalance),
                    colorAmountBySign: true,
                )
                Spacer()
            }

            Section("Rounds") {
                ForEach(Array(viewModel.model.roundRows), id: \.round.id) { row in
                    roundRow(round: row.round, balance: row.balance)
                }
                .onDelete { indexSet in
                    let rows = viewModel.model.roundRows
                    for index in indexSet {
                        guard rows.indices.contains(index) else { continue }
                        viewModel.deleteRound(id: rows[index].round.id)
                    }
                }
            }
            
            resetSection
        }
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
        .background(Color.clear)
    }
    
    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                showResetConfirmation = true
            } label: {
                Text("Reset session")
            }
        } footer: {
            Text("Clears all of your bet history. This cannot be undone.")
                .font(DesignTokens.Typography.caption)
        }
    }

    @ViewBuilder
    private func roundRow(round: Round, balance: Double) -> some View {
        if let result = round.result {
            finishedRound(round: round, balance: balance, result: result)
        } else {
            pendingRoundRow(round: round)
        }

    }

    private func finishedRound(round: Round, balance: Double, result: Outcome) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text((round.endDate ?? round.startDate), format: .dateTime.hour().minute())
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(result.rawValue.capitalized)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }
            if round.profit != 0 {
                HStack {
                    Text(round.profit > 0 ? "Win" : "Lose")
                        .font(DesignTokens.Typography.body)
                    Spacer()
                    CurrencyLabel(amount: round.profit, showPlusForPositive: true)
                }
            }

            HStack {
                Text("Running Balance")
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                CurrencyLabel(amount: balance)
            }
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
    }

    private func pendingRoundRow(round: Round) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack(spacing: DesignTokens.Spacing.medium) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(round.totalStaked, format: Formatters.currencyDisplayFormat)
                        + Text(" wagered")
                        .font(DesignTokens.Typography.bodyPrimary)
                    Text("Awaiting result")
                        .font(DesignTokens.Typography.bodyPrimary)
                }

                Spacer()
                CoinOutcomeButton(outcome: .heads) {
                    viewModel.recordOutcome(roundId: round.id, outcome: .heads)
                }
                CoinOutcomeButton(outcome: .tails) {
                    viewModel.recordOutcome(roundId: round.id, outcome: .tails)
                }
            }
            .accessibilityElement(children: .contain)
        }
    }
}

extension SessionDetailView {
    struct Model {
        var session: Session = .defaultSession()

        var sessionName: String { session.name }
        var currentBalance: Double { session.currentBalance }
        var hasRounds: Bool { !session.rounds.isEmpty }

        /// Newest rounds first; each pair is the round and running balance after that round.
        var roundRows: [(round: Round, balance: Double)] {
            session.runningBalances().reversed()
        }
    }
}

// MARK: - Previews

private enum SessionDetailPreviewSessions {
    static let baseDate = Date(timeIntervalSince1970: 1_745_462_400)

    static var empty: Session {
        Session(
            id: UUID(),
            name: "Anzac Day 2026",
            date: baseDate,
            year: 2026,
            rounds: []
        )
    }

    static var withRounds: Session {
        Session(
            id: UUID(),
            name: "Anzac Day 2026",
            date: baseDate,
            year: 2026,
            rounds: [
                Round(
                    id: UUID(),
                    startDate: baseDate.addingTimeInterval(300),
                    endDate: baseDate.addingTimeInterval(420),
                    result: .heads,
                    bets: [
                        Bet(id: UUID(), amount: 50, prediction: .heads),
                        Bet(id: UUID(), amount: 30, prediction: .tails),
                    ]
                ),
                Round(
                    id: UUID(),
                    startDate: baseDate.addingTimeInterval(600),
                    endDate: nil,
                    result: nil,
                    bets: [
                        Bet(id: UUID(), amount: 20, prediction: .heads),
                    ]
                ),
            ]
        )
    }
}

#Preview("Empty") {
    let assembler = TwoUpTrackerAssembly.testing()
    let viewModel = assembler.resolver.sessionDetailViewModel()
    viewModel.mainStore.activeSession = SessionDetailPreviewSessions.empty
    return SessionDetailView(viewModel: viewModel)
}

#Preview("With rounds") {
    let assembler = TwoUpTrackerAssembly.testing()
    let viewModel = assembler.resolver.sessionDetailViewModel()
    viewModel.mainStore.activeSession = SessionDetailPreviewSessions.withRounds
    return SessionDetailView(viewModel: viewModel)
}
