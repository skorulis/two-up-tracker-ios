import Foundation

struct Round: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var date: Date
    var result: Outcome?
    var bets: [Bet]
}

extension Round {
    /// Sum of per-bet profit/loss for this round’s toss result.
    var profit: Double {
        guard let result else { return 0 }
        return bets.reduce(0) { $0 + $1.profit(for: result) }
    }
}
