import Foundation

struct Session: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var date: Date
    var rounds: [Round]
}

extension Session {

    /// Cumulative balance after each round, in chronological order.
    func runningBalances() -> [(round: Round, balance: Double)] {
        var balance = 0.0
        return rounds.map { round in
            balance += round.profit
            return (round, balance)
        }
    }
}
