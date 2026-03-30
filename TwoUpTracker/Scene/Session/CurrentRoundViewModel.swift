import ASKCoordinator
import Combine
import Foundation
import Knit
import SwiftUI
import KnitMacros
import Observation

@MainActor
@Observable
final class CurrentRoundViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    let mainStore: MainStore

    private var cancellables: Set<AnyCancellable> = []

    var model: CurrentRoundView.Model = .init()

    @Resolvable<BaseResolver>
    init(mainStore: MainStore, countdownService: CountdownService) {
        self.mainStore = mainStore
        mainStore.$activeSession.sink { [unowned self] session in
            self.model.session = session
        }
        .store(in: &cancellables)
        
        countdownService.$countdownFinished.sink { [unowned self] in
            self.model.bettingAvailable = $0
        }
        .store(in: &cancellables)
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

    func addAnotherBet() {
        let path = MainPath.addBet { [unowned self] bet in
            var session = self.mainStore.activeSession
            guard var round = session.rounds.last else {
                return
            }
            round.bets.append(bet)
            session.rounds[session.rounds.count - 1] = round
            self.mainStore.activeSession = session
        }
        coordinator?.custom(overlay: .card, path)
    }

    @discardableResult
    func saveRound(bet: Bet) -> Bool {
        let round = Round(id: UUID(), date: Date(), result: nil, bets: [bet])
        mainStore.appendRound(round)
        return true
    }

    func resetForm() {
        model.betDrafts = [BetDraft(id: UUID(), amountText: "", prediction: .heads)]
        mainStore.activeSession.resetOutstanding()
    }

    func showTwoUpAvailabilityInfo() {
        coordinator?.custom(overlay: .card, MainPath.twoUpAvailabilityInfo)
    }

    func recordPendingOutcome(_ outcome: Outcome) {
        guard let id = model.pendingRoundAwaitingResult?.id else { return }
        mainStore.setRoundResult(roundId: id, result: outcome)
        resetForm()
    }
}
