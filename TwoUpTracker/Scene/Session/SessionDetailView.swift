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
                    message: "Use the Add tab to record a toss and your bets.",
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
                            }
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
            }
        }
    }
}
