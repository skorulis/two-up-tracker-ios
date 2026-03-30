import Combine
import Foundation
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class SessionDetailViewModel {
    let mainStore: MainStore
    var model: SessionDetailView.Model = .init()

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<BaseResolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore

        mainStore.$activeSession.sink { [unowned self] in
            self.model.session = $0
        }
        .store(in: &cancellables)
    }

    func recordOutcome(roundId: UUID, outcome: Outcome) {
        mainStore.setRoundResult(roundId: roundId, result: outcome)
    }

    func deleteRound(id: UUID) {
        mainStore.removeRound(id: id)
    }
}
