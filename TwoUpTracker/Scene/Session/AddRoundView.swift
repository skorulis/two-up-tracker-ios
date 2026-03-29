import ASKCoordinator
import SwiftUI

struct AddRoundView: View {
    @Bindable var model: AddRoundViewModel
    @Bindable var store: MainStore
    @Environment(\.coordinator) private var coordinator

    var body: some View {
        Form {
            if let pending = model.pendingRoundAwaitingResult {
                pendingTossSection(for: pending)
            } else {
                addBetsSections
            }
        }
        .id("\(store.activeSession.rounds.count)-\(model.pendingRoundAwaitingResult?.id.uuidString ?? "no-pending")")
        .navigationTitle(model.pendingRoundAwaitingResult != nil ? "Record toss" : "Outstanding bets")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(coordinator?.canPop == true ? "Cancel" : "Clear") {
                    if coordinator?.canPop == true {
                        coordinator?.pop()
                    } else {
                        model.resetForm()
                    }
                }
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
                Text(round.totalStaked, format: .currency(code: Locale.current.currency?.identifier ?? "AUD"))
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
                    Text(bet.amount, format: .currency(code: Locale.current.currency?.identifier ?? "AUD"))
                        .font(DesignTokens.Typography.body.monospacedDigit())
                }
                .accessibilityElement(children: .combine)
            }
        } header: {
            Text("Your bets")
        }

        Section {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Text("Toss")
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Heads") {
                    model.recordPendingOutcome(.heads)
                }
                .buttonStyle(.bordered)
                Button("Tails") {
                    model.recordPendingOutcome(.tails)
                }
                .buttonStyle(.bordered)
            }
            .accessibilityElement(children: .contain)
        } footer: {
            Text("Choose the coin toss result to update your P&L for this round.")
                .font(DesignTokens.Typography.caption)
        }
    }

    private var addBetsSections: some View {
        Group {
            Section {
                ForEach(model.betDrafts) { draft in
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        BetAmountGrid(amountText: model.amountBinding(for: draft.id))
                        HStack {
                            TextField("Amount", text: model.amountBinding(for: draft.id))
                                .keyboardType(.decimalPad)
                                .font(DesignTokens.Typography.body.monospacedDigit())
                            Picker("Prediction", selection: model.predictionBinding(for: draft.id)) {
                                ForEach(Outcome.allCases, id: \.self) { outcome in
                                    Text(outcome.rawValue.capitalized).tag(outcome)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(minWidth: 160)
                        }
                        saveButton
                    }
                }
            } header: {
                Text("Bets")
            }
        }
    }

    private var saveButton: some View {
        Button("Set bet") {
            guard model.saveRound() else { return }
            if coordinator?.canPop == true {
                coordinator?.pop()
            } else {
                model.resetForm()
            }
        }
        .buttonStyle(.primary)
        .disabled(!model.canSave)
    }
}
