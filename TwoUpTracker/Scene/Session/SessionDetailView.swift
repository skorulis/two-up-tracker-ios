import SwiftUI

struct SessionDetailView: View {
    @State var model: SessionDetailViewModel

    var body: some View {
        PageLayout {
            PageHeader(title: model.sessionName)
        } content: {
            if model.hasRounds {
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
        .id(model.mainStore.activeSession.rounds.count)
        .navigationBarHidden(true)
    }

    private var listContent: some View {
        List {
            balance
            Text("Rounds")
            Section {
                ForEach(Array(model.roundRows), id: \.round.id) { row in
                    roundRow(round: row.round, balance: row.balance)
                }
                .onDelete { indexSet in
                    let rows = model.roundRows
                    for index in indexSet {
                        guard rows.indices.contains(index) else { continue }
                        model.deleteRound(id: rows[index].round.id)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
        .background(Color.clear)
    }

    private func roundRow(round: Round, balance: Double) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text((round.endDate ?? round.startDate), format: .dateTime.hour().minute())
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if let result = round.result {
                    Text(result.rawValue.capitalized)
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Outcome pending")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                }
            }
            if round.result == nil {
                HStack(spacing: DesignTokens.Spacing.medium) {
                    Text("Toss")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    CoinOutcomeButton(outcome: .heads) {
                        model.recordOutcome(roundId: round.id, outcome: .heads)
                    }
                    CoinOutcomeButton(outcome: .tails) {
                        model.recordOutcome(roundId: round.id, outcome: .tails)
                    }
                }
                .accessibilityElement(children: .contain)
            } else {
                HStack {
                    Text("Result")
                        .font(DesignTokens.Typography.body)
                    Spacer()
                    CurrencyLabel(amount: round.profit)
                }
                HStack {
                    Text("Running Balance")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    CurrencyLabel(amount: balance)
                }
            }
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
    }

    private var balance: some View {
        Section {
            Card {
                HStack {
                    Text("Balance")
                        .font(DesignTokens.Typography.headline)
                    Spacer()
                    CurrencyLabel(amount: model.currentBalance)
                }
                .accessibilityElement(children: .combine)
            }
            .listRowSeparator(.hidden)
        }
    }
}
