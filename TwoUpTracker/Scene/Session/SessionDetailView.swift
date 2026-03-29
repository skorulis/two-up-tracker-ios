import SwiftUI

struct SessionDetailView: View {
    @Bindable var model: SessionDetailViewModel
    @Bindable var store: MainStore

    var body: some View {
        Group {
            if model.hasRounds {
                listContent
            } else {
                EmptyState(
                    title: "No rounds yet",
                    message: "Use the Add tab to enter your outstanding bets, then record the toss outcome here when you know it.",
                    systemImage: "list.bullet.rectangle"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .id(store.activeSession.rounds.count)
        .navigationTitle(model.sessionName)
        .navigationBarTitleDisplayMode(.large)
    }

    private var listContent: some View {
        List {
            Section {
                HStack {
                    Text("Balance")
                        .font(DesignTokens.Typography.headline)
                    Spacer()
                    CurrencyLabel(amount: model.currentBalance)
                }
                .accessibilityElement(children: .combine)
            }
            Section("Rounds") {
                ForEach(Array(model.roundRows), id: \.round.id) { row in
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        HStack {
                            Text(row.round.date, format: .dateTime.day().month().year().hour().minute())
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            if let result = row.round.result {
                                Text(result.rawValue.capitalized)
                                    .font(DesignTokens.Typography.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Outcome pending")
                                    .font(DesignTokens.Typography.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        if row.round.result == nil {
                            HStack(spacing: DesignTokens.Spacing.medium) {
                                Text("Toss")
                                    .font(DesignTokens.Typography.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                CoinOutcomeButton(outcome: .heads) {
                                    model.recordOutcome(roundId: row.round.id, outcome: .heads)
                                }
                                CoinOutcomeButton(outcome: .tails) {
                                    model.recordOutcome(roundId: row.round.id, outcome: .tails)
                                }
                            }
                            .accessibilityElement(children: .contain)
                        }
                        HStack {
                            Text("Round P&L")
                                .font(DesignTokens.Typography.body)
                            Spacer()
                            CurrencyLabel(amount: row.round.profit)
                        }
                        HStack {
                            Text("Running")
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            CurrencyLabel(amount: row.balance)
                        }
                    }
                    .padding(.vertical, DesignTokens.Spacing.xs)
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
    }
}
