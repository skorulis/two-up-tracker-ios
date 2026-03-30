import Foundation

struct Round: Identifiable, Hashable, Sendable {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var result: Outcome?
    var bets: [Bet]
}

extension Round: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, startDate, endDate, result, bets
        case date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        if let start = try container.decodeIfPresent(Date.self, forKey: .startDate) {
            startDate = start
        } else if let legacy = try container.decodeIfPresent(Date.self, forKey: .date) {
            startDate = legacy
        } else {
            throw DecodingError.keyNotFound(
                CodingKeys.startDate,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected startDate or legacy date key."
                )
            )
        }
        endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        result = try container.decodeIfPresent(Outcome.self, forKey: .result)
        bets = try container.decode([Bet].self, forKey: .bets)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
        try container.encodeIfPresent(result, forKey: .result)
        try container.encode(bets, forKey: .bets)
    }
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
