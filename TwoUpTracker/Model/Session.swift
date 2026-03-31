import Foundation

struct Session: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var date: Date
    /// Calendar year for this session (e.g. which Anzac Day season).
    var year: Int
    var rounds: [Round]
}

extension Session {

    var bettingStartTime: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = 4
        components.day = 25
        components.hour = 12
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)!
    }

    static func defaultSession() -> Session {
        let year = Calendar.current.component(.year, from: Date())
        return Session(
            id: UUID(),
            name: "Anzac Day \(year)",
            date: Date(),
            year: year,
            rounds: []
        )
    }

    var roundsOrdered: [Round] {
        rounds.sorted { $0.startDate < $1.startDate }
    }

    /// Cumulative balance after each round, in chronological order.
    func runningBalances() -> [(round: Round, balance: Double)] {
        var balance = 0.0
        return roundsOrdered.map { round in
            balance += round.profit
            return (round, balance)
        }
    }
    
    var currentBalance: Double { runningBalances().last?.1 ?? 0 }

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
