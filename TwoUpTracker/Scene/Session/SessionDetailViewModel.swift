import Foundation
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class SessionDetailViewModel {
    private let mainStore: MainStore

    @Resolvable<BaseResolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    var sessionName: String {
        mainStore.activeSession.name
    }

    /// Newest rounds first; each pair is the round and running balance after that round.
    var roundRows: [(round: Round, balance: Double)] {
        mainStore.activeSession.runningBalances().reversed()
    }

    var currentBalance: Double {
        mainStore.activeSession.runningBalances().last?.1 ?? 0
    }

    var hasRounds: Bool {
        !mainStore.activeSession.rounds.isEmpty
    }
}
