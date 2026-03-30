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
            if session.rounds.count > 0 && !self.model.bettingAvailable {
                self.model.bettingAvailable = true
            }
        }
        .store(in: &cancellables)

        countdownService.$countdownFinished.sink { [unowned self] in
            if $0 && !self.model.bettingAvailable {
                self.model.bettingAvailable = true
            }
        }
        .store(in: &cancellables)
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
