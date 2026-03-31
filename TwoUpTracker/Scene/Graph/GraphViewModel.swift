import Combine
import Foundation
import Knit
import KnitMacros
import Observation

/// One point on the running-balance line: X = time, Y = cumulative balance after that moment.
struct BalanceChartPoint: Identifiable, Equatable, Sendable {
    let id: Int
    let date: Date
    let balance: Double
}

@MainActor
@Observable
final class GraphViewModel {
    let mainStore: MainStore
    private var cancellables: Set<AnyCancellable> = []

    private(set) var session: Session
    
    private(set) var settings: Settings

    @Resolvable<BaseResolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
        self.session = mainStore.activeSession
        self.settings = mainStore.settings

        mainStore.$activeSession.sink { [unowned self] in
            self.session = $0
        }
        .store(in: &cancellables)
        
        mainStore.$settings.sink { [unowned self] in
            self.settings = $0
        }
        .store(in: &cancellables)
    }
}

extension Session {
    /// Chronological series: opens at $0 on the first round’s `startDate`, then one point per resolved
    /// round at that round’s `endDate` (fallback `startDate` if legacy data has no `endDate`).
    var balanceSeries: [BalanceChartPoint] {
        let pairs = resolvedRunningBalances()
        guard let originDate = roundsOrdered.first?.startDate,
              !pairs.isEmpty
        else { return [] }

        var points: [BalanceChartPoint] = [
            BalanceChartPoint(id: 0, date: originDate, balance: 0),
        ]
        for (index, pair) in pairs.enumerated() {
            let round = pair.round
            let date = round.endDate ?? round.startDate
            points.append(BalanceChartPoint(id: index + 1, date: date, balance: pair.balance))
        }
        return points
    }

    var hasGraphData: Bool {
        !balanceSeries.isEmpty
    }

    private var resolvedRounds: [Round] {
        roundsOrdered.filter { $0.result != nil }
    }

    private var winCount: Int {
        return resolvedRounds.map { round in
            round.bets.count { bet in bet.prediction == round.result }
        }
        .reduce(0, +)
    }

    private var lossCount: Int {
        return resolvedRounds.map { round in
            round.bets.count { bet in bet.prediction.opposite == round.result }
        }
        .reduce(0, +)
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
