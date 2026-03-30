import Combine
import Foundation
import Knit
import SwiftUI
import KnitMacros
import Observation

@MainActor
@Observable
final class AddRoundViewModel {
    private let mainStore: MainStore
    
    private var cancellables: Set<AnyCancellable> = []

    var model: CurrentRoundView.Model = .init()

    @Resolvable<BaseResolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
        mainStore.$activeSession.sink { [unowned self] session in
            self.model.session = session
        }
        .store(in: &cancellables)
    }

    var canSave: Bool {
        makeRound() != nil
    }

    func addBet() {
        model.betDrafts.append(BetDraft(id: UUID(), amountText: "", prediction: .heads))
    }

    func removeBet(id: UUID) {
        model.betDrafts.removeAll { $0.id == id }
        if model.betDrafts.isEmpty {
            model.betDrafts = [BetDraft(id: UUID(), amountText: "", prediction: .heads)]
        }
    }

    func amountBinding(for id: UUID) -> Binding<String> {
        Binding(
            get: { self.model.betDrafts.first { $0.id == id }?.amountText ?? "" },
            set: { newValue in
                if let index = self.model.betDrafts.firstIndex(where: { $0.id == id }) {
                    self.model.betDrafts[index].amountText = newValue
                }
            }
        )
    }

    func predictionBinding(for id: UUID) -> Binding<Outcome> {
        Binding(
            get: { self.model.betDrafts.first { $0.id == id }?.prediction ?? .heads },
            set: { newValue in
                if let index = self.model.betDrafts.firstIndex(where: { $0.id == id }) {
                    self.model.betDrafts[index].prediction = newValue
                }
            }
        )
    }

    @discardableResult
    func saveRound() -> Bool {
        guard let round = makeRound() else { return false }
        mainStore.appendRound(round)
        return true
    }

    func resetForm() {
        model.betDrafts = [BetDraft(id: UUID(), amountText: "", prediction: .heads)]
        mainStore.activeSession.resetOutstanding()
    }

    func recordPendingOutcome(_ outcome: Outcome) {
        guard let id = model.pendingRoundAwaitingResult?.id else { return }
        mainStore.setRoundResult(roundId: id, result: outcome)
        resetForm()
    }

    private func makeRound() -> Round? {
        let bets: [Bet] = model.betDrafts.compactMap { draft in
            let trimmed = draft.amountText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let value = Double(trimmed), value > 0 else { return nil }
            return Bet(id: UUID(), amount: value, prediction: draft.prediction)
        }
        guard !bets.isEmpty else { return nil }
        return Round(id: UUID(), date: Date(), result: nil, bets: bets)
    }
}
