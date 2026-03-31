import Foundation

struct Round: Identifiable, Hashable, Sendable, Codable {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var result: Outcome?
    var bets: [Bet]
}

extension Round {
    /// Sum of per-bet profit/loss if the toss were `outcome` (same as ``profit`` once that outcome is recorded).
    func netProfit(for outcome: Outcome) -> Double {
        bets.reduce(0) { $0 + $1.profit(for: outcome) }
    }

    /// Sum of per-bet profit/loss for this round’s toss result.
    var profit: Double {
        guard let result else { return 0 }
        return netProfit(for: result)
    }

    /// Total amount staked across all bets in this round (before the toss).
    var totalStaked: Double {
        bets.reduce(0) { $0 + $1.amount }
    }
}
