//  Created by Alex Skorulis on 31/3/2026.

import Foundation

struct TestData {
    func realisticSession() -> Session {
        var session = Session(
            id: UUID(),
            name: "Anzac Day 2026",
            date: Date(timeIntervalSince1970: 1_745_462_400), // 2025-04-25 12:00:00 UTC
            year: 2026,
            rounds: []
        )

        // Realistic sequence: mixed stakes, mixed predictions, and one unresolved round.
        session.rounds = [
            makeRound(index: 1, result: .heads, bets: [(10, .heads)]),
            makeRound(index: 2, result: .tails, bets: [(15, .heads)]),
            makeRound(index: 3, result: .heads, bets: [(25, .tails)]),
            makeRound(index: 4, result: .tails, bets: [(10, .heads)]),
            makeRound(index: 5, result: .tails, bets: [(30, .tails)]),
            makeRound(index: 6, result: .heads, bets: [(20, .heads)]),
            makeRound(index: 7, result: .tails, bets: [(25, .tails)]),
            makeRound(index: 8, result: .heads, bets: [(40, .heads)]),
            makeRound(index: 9, result: .tails, bets: [(35, .heads)]),
            makeRound(index: 10, result: .heads, bets: [(50, .heads)]),
            makeRound(index: 11, result: .tails, bets: [(30, .tails)]),
            makeRound(index: 12, result: nil, bets: [(20, .heads)]),
        ]

        return session
    }

    func makeRound(index: Int, result: Outcome?, bets: [(Double, Outcome)]) -> Round {
        let base = Date(timeIntervalSince1970: 1_745_462_400)
        let startDate = base.addingTimeInterval(TimeInterval(index * 420))
        let endDate: Date? = result == nil ? nil : startDate.addingTimeInterval(120)
        return Round(
            id: UUID(),
            startDate: startDate,
            endDate: endDate,
            result: result,
            bets: bets.map { bet in
                Bet(
                    id: UUID(),
                    amount: bet.0,
                    prediction: bet.1
                )
            }
        )
    }
}
