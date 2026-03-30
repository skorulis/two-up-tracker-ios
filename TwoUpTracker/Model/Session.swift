import Foundation

struct Session: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var date: Date
    /// Calendar year for this session (e.g. which Anzac Day season).
    var year: Int
    var rounds: [Round]

    enum CodingKeys: String, CodingKey {
        case id, name, date, year, rounds
    }

    init(id: UUID, name: String, date: Date, year: Int, rounds: [Round]) {
        self.id = id
        self.name = name
        self.date = date
        self.year = year
        self.rounds = rounds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        date = try container.decode(Date.self, forKey: .date)
        rounds = try container.decode([Round].self, forKey: .rounds)
        if let decodedYear = try container.decodeIfPresent(Int.self, forKey: .year) {
            year = decodedYear
        } else {
            year = Calendar.current.component(.year, from: date)
        }
    }
}

extension Session {

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
