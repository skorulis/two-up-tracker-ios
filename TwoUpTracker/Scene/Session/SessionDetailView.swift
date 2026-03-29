import ASKCoordinator
import SwiftUI

struct SessionDetailView: View {
    @Bindable var model: SessionDetailViewModel
    @Environment(\.coordinator) private var coordinator

    var body: some View {
        Group {
            if model.hasRounds {
                listContent
            } else {
                EmptyState(
                    title: "No rounds yet",
                    message: "Add a round to record the toss and your bets.",
                    systemImage: "list.bullet.rectangle"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(model.sessionName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add round") {
                    coordinator?.push(MainPath.addRound)
                }
            }
        }
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
                            Text(row.round.result.rawValue.capitalized)
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(.secondary)
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
