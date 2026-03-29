import Foundation

struct Session: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var date: Date
    var rounds: [Round]
}

extension Session {

    var roundsOrdered: [Round] {
        rounds.sorted { $0.date < $1.date }
    }

    /// Cumulative balance after each round, in chronological order.
    func runningBalances() -> [(round: Round, balance: Double)] {
        var balance = 0.0
        return roundsOrdered.map { round in
            balance += round.profit
            return (round, balance)
        }
    }
}
