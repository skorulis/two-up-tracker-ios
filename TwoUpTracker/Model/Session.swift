import Foundation

struct Session: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var date: Date
    var rounds: [Round]
}

extension Session {
    
    static func defaultSession() -> Session {
        let year = Calendar.current.component(.year, from: Date())
        return Session(
            id: UUID(),
            name: "Anzac Day \(year)",
            date: Date(),
            rounds: []
        )
    }

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

    /// Cumulative balance after each round that has a recorded toss outcome, in chronological order.
    func resolvedRunningBalances() -> [(round: Round, balance: Double)] {
        var balance = 0.0
        return roundsOrdered.filter { $0.result != nil }.map { round in
            balance += round.profit
            return (round, balance)
        }
    }
    
    mutating func resetOutstanding() {
        let index = rounds.firstIndex(where: { $0.result == nil })
        guard let index else { return}
        rounds.remove(at: index)
    }
}
