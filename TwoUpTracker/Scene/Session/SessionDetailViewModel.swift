import Combine
import Foundation
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class SessionDetailViewModel {
    let mainStore: MainStore
    private let analyticsService: AnalyticsService
    var model: SessionDetailView.Model = .init()

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore, analyticsService: AnalyticsService) {
        self.mainStore = mainStore
        self.analyticsService = analyticsService

        mainStore.$activeSession.sink { [unowned self] in
            self.model.session = $0
        }
        .store(in: &cancellables)
    }

    func recordOutcome(roundId: UUID, outcome: Outcome) {
        mainStore.setRoundResult(roundId: roundId, result: outcome)
        analyticsService.trackBetResultSetFromSessionDetails()
    }

    func deleteRound(id: UUID) {
        mainStore.removeRound(id: id)
    }

    func resetSessionData() {
        mainStore.activeSession = .defaultSession()
    }
}
