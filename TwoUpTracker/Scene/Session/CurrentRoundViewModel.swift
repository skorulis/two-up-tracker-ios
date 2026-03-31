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
    private let analyticsService: AnalyticsService

    private var cancellables: Set<AnyCancellable> = []

    var model: CurrentRoundView.Model = .init()

    @Resolvable<BaseResolver>
    init(mainStore: MainStore, countdownService: CountdownService, analyticsService: AnalyticsService) {
        self.mainStore = mainStore
        self.analyticsService = analyticsService
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
            self.analyticsService.trackBetSet()
        }
        coordinator?.custom(overlay: .card, path)
    }

    @discardableResult
    func saveRound(bet: Bet) -> Bool {
        let round = Round(id: UUID(), startDate: Date(), endDate: nil, result: nil, bets: [bet])
        mainStore.appendRound(round)
        analyticsService.trackBetSet()
        return true
    }

    func resetForm() {
        resetOutstanding(trackEvent: true)
    }

    func showTwoUpAvailabilityInfo() {
        coordinator?.custom(overlay: .card, MainPath.twoUpAvailabilityInfo)
    }

    func showWhatIsTwoUp() {
        coordinator?.push(MainPath.whatIsTwoUp)
    }

    func recordPendingOutcome(_ outcome: Outcome) {
        guard let id = model.pendingRoundAwaitingResult?.id else { return }
        mainStore.setRoundResult(roundId: id, result: outcome)
        analyticsService.trackBetResultConfirmed()
        resetOutstanding(trackEvent: false)
    }

    private func resetOutstanding(trackEvent: Bool) {
        mainStore.activeSession.resetOutstanding()
        if trackEvent {
            analyticsService.trackBetReset()
        }
    }
}
