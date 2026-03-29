import Foundation

struct Bet: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var amount: Double
    var prediction: Outcome
}

extension Bet {
    /// Win `+amount` when prediction matches the toss; otherwise `-amount`.
    func profit(for result: Outcome) -> Double {
        prediction == result ? amount : -amount
    }
}
