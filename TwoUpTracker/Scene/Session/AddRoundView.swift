import ASKCoordinator
import SwiftUI

struct AddRoundView: View {
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
                addBetsSections
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

    private var addBetsSections: some View {
        Group {
            Section {
                ForEach(viewModel.model.betDrafts) { draft in
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.small) {
                        BetAmountGrid(amountText: viewModel.amountBinding(for: draft.id))
                        HStack {
                            TextField("Amount", text: viewModel.amountBinding(for: draft.id))
                                .keyboardType(.decimalPad)
                                .font(DesignTokens.Typography.body.monospacedDigit())
                            Picker("Prediction", selection: viewModel.predictionBinding(for: draft.id)) {
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
            viewModel.saveRound()
        }
        .buttonStyle(.primary)
        .disabled(!viewModel.canSave)
    }
}

struct BetDraft: Identifiable, Equatable {
    let id: UUID
    var amountText: String
    var prediction: Outcome
}

extension AddRoundView {
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
