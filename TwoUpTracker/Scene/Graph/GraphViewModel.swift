import Foundation
import Knit
import KnitMacros
import Observation

/// One point on the running-balance line (PRD: X = round index, Y = cumulative balance).
struct BalanceChartPoint: Identifiable, Equatable, Sendable {
    var id: Int { roundIndex }
    let roundIndex: Int
    let balance: Double
}

@MainActor
@Observable
final class GraphViewModel {
    private let mainStore: MainStore

    @Resolvable<BaseResolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    var sessionName: String {
        mainStore.activeSession.name
    }

    /// Chronological series: balance after each round, indexed 1…n.
    var balanceSeries: [BalanceChartPoint] {
        let pairs = mainStore.activeSession.runningBalances()
        return pairs.enumerated().map { index, pair in
            BalanceChartPoint(roundIndex: index + 1, balance: pair.balance)
        }
    }

    var hasData: Bool {
        !mainStore.activeSession.rounds.isEmpty
    }

    var currentBalance: Double {
        mainStore.activeSession.runningBalances().last?.balance ?? 0
    }
}
