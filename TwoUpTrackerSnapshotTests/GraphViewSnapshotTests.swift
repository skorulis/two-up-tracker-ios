@testable import TwoUpTracker
import Knit
import SnapshotTesting
import SwiftUI
import Testing

@MainActor @Suite(.snapshots(record: .failed))
struct GraphViewSnapshotTests {

    private let assembler = TwoUpTrackerAssembly.testing()

    @Test func graphWithRealisticData() async throws {
        let viewModel = assembler.resolver.graphViewModel()
        viewModel.mainStore.activeSession = realisticSession()

        let view = GraphView(model: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe))
    }

    @Test func graphWithRealisticDataDarkMode() async throws {
        let viewModel = assembler.resolver.graphViewModel()
        viewModel.mainStore.activeSession = realisticSession()

        let view = GraphView(model: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe), style: .dark)
    }

    private func realisticSession() -> Session {
        var session = Session(
            id: UUID(),
            name: "Anzac Day 2026",
            date: Date(timeIntervalSince1970: 1_745_462_400), // 2025-04-25 12:00:00 UTC
            year: 2026,
            rounds: []
        )

        // Realistic sequence: mixed stakes, mixed predictions, and one unresolved round.
        session.rounds = [
            makeRound(index: 1, result: .heads, bets: [(10, .heads), (10, .tails), (20, .heads)]),
            makeRound(index: 2, result: .tails, bets: [(15, .heads), (10, .tails)]),
            makeRound(index: 3, result: .heads, bets: [(25, .tails), (20, .heads)]),
            makeRound(index: 4, result: .heads, bets: [(10, .heads), (10, .heads), (5, .tails)]),
            makeRound(index: 5, result: .tails, bets: [(30, .tails), (20, .heads)]),
            makeRound(index: 6, result: .heads, bets: [(20, .heads), (20, .tails), (10, .heads)]),
            makeRound(index: 7, result: .tails, bets: [(25, .tails), (10, .tails), (10, .heads)]),
            makeRound(index: 8, result: .heads, bets: [(40, .heads), (20, .tails)]),
            makeRound(index: 9, result: .tails, bets: [(35, .heads), (15, .tails)]),
            makeRound(index: 10, result: .heads, bets: [(50, .heads), (20, .heads), (20, .tails)]),
            makeRound(index: 11, result: .tails, bets: [(30, .tails), (10, .heads)]),
            makeRound(index: 12, result: nil, bets: [(20, .heads), (20, .tails)]),
        ]

        return session
    }

    private func makeRound(index: Int, result: Outcome?, bets: [(Double, Outcome)]) -> Round {
        let base = Date(timeIntervalSince1970: 1_745_462_400)
        return Round(
            id: UUID(),
            date: base.addingTimeInterval(TimeInterval(index * 420)),
            result: result,
            bets: bets.enumerated().map { betIndex, bet in
                Bet(
                    id: UUID(),
                    amount: bet.0,
                    prediction: bet.1
                )
            }
        )
    }
}
