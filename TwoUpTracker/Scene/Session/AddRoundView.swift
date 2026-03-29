import ASKCoordinator
import SwiftUI

struct AddRoundView: View {
    @Bindable var model: AddRoundViewModel
    @Environment(\.coordinator) private var coordinator

    var body: some View {
        Form {
            Section {
                Picker("Toss result", selection: $model.tossResult) {
                    ForEach(Outcome.allCases, id: \.self) { outcome in
                        Text(outcome.rawValue.capitalized).tag(outcome)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Toss result")
            } header: {
                Text("Result")
            }

            Section {
                ForEach(model.betDrafts) { draft in
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
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
                            if model.betDrafts.count > 1 {
                                Button(role: .destructive) {
                                    model.removeBet(id: draft.id)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                }
                                .accessibilityLabel("Remove bet")
                            }
                        }
                    }
                }
            } header: {
                Text("Bets")
            } footer: {
                Text("At least one bet with a positive amount is required.")
                    .font(DesignTokens.Typography.caption)
            }

            Section {
                Button("Add another bet") {
                    model.addBet()
                }
                Button("Save round") {
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
        .navigationTitle("New round")
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
}
