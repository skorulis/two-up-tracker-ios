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
    let mainStore: MainStore

    @Resolvable<BaseResolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    var sessionName: String {
        mainStore.activeSession.name
    }

    /// Chronological series: balance after each resolved round, indexed 1…n.
    var balanceSeries: [BalanceChartPoint] {
        let pairs = mainStore.activeSession.resolvedRunningBalances()
        return pairs.enumerated().map { index, pair in
            BalanceChartPoint(roundIndex: index + 1, balance: pair.balance)
        }
    }

    var hasData: Bool {
        !balanceSeries.isEmpty
    }

    var currentBalance: Double {
        mainStore.activeSession.resolvedRunningBalances().last?.balance ?? 0
    }

    private var resolvedRounds: [Round] {
        mainStore.activeSession.roundsOrdered.filter { $0.result != nil }
    }

    private var winCount: Int {
        resolvedRounds.filter { $0.profit > 0 }.count
    }

    private var lossCount: Int {
        resolvedRounds.filter { $0.profit < 0 }.count
    }

    private var headsCount: Int {
        resolvedRounds.filter { $0.result == .heads }.count
    }

    private var tailsCount: Int {
        resolvedRounds.filter { $0.result == .tails }.count
    }

    /// Wins ÷ (wins + losses); pushes excluded. "—" when there are no wins or losses yet.
    var winPercentageText: String {
        let wins = winCount
        let losses = lossCount
        let decisive = wins + losses
        guard decisive > 0 else { return "—" }
        let percent = Double(wins) / Double(decisive) * 100
        return String(format: "%.0f%%", percent)
    }

    var winLossRecordText: String {
        "\(winCount)W · \(lossCount)L"
    }

    /// e.g. "60% heads, 40% tails"; percentages sum to 100%.
    var headsTailsPercentageText: String {
        let heads = headsCount
        let tails = tailsCount
        let total = heads + tails
        guard total > 0 else { return "—" }
        let headsRounded = Int((Double(heads) / Double(total) * 100).rounded())
        let tailsRounded = 100 - headsRounded
        return "\(headsRounded)% heads, \(tailsRounded)% tails"
    }
}
