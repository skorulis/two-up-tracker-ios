@testable import TwoUpTracker
import Knit
import SnapshotTesting
import SwiftUI
import Testing

@MainActor @Suite(.snapshots(record: .failed))
struct CurrentRoundViewSnapshotTests {

    private let assembler = TwoUpTrackerAssembly.testing()

    /// Pending toss UI (no `CountdownTimer`).
    @Test func pendingRound() async throws {
        let viewModel = assembler.resolver.currentRoundViewModel()
        viewModel.mainStore.activeSession = sessionWithPendingRound()
        viewModel.model.bettingAvailable = true

        let view = CurrentRoundView(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe))
    }

    @Test func pendingRoundDarkMode() async throws {
        let viewModel = assembler.resolver.currentRoundViewModel()
        viewModel.mainStore.activeSession = sessionWithPendingRound()
        viewModel.model.bettingAvailable = true

        let view = CurrentRoundView(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe), style: .dark)
    }

    /// `AddBetView` path: `bettingStartTime` is in the past so the timeline never shows `CountdownTimer`.
    @Test func addBetBettingWindowOpen() async throws {
        let viewModel = assembler.resolver.currentRoundViewModel()
        viewModel.mainStore.activeSession = sessionWithBettingStartInThePast()
        viewModel.model.bettingAvailable = true

        let view = CurrentRoundView(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe))
    }

    @Test func addBetBettingWindowOpenDarkMode() async throws {
        let viewModel = assembler.resolver.currentRoundViewModel()
        viewModel.mainStore.activeSession = sessionWithBettingStartInThePast()
        viewModel.model.bettingAvailable = true

        let view = CurrentRoundView(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe), style: .dark)
    }

    private var baseDate: Date { Date(timeIntervalSince1970: 1_745_462_400) }

    private func sessionWithPendingRound() -> Session {
        Session(
            id: UUID(),
            name: "Anzac Day 2026",
            date: baseDate,
            year: 2026,
            rounds: [
                Round(
                    id: UUID(),
                    date: baseDate.addingTimeInterval(300),
                    result: nil,
                    bets: [
                        Bet(
                            id: UUID(),
                            amount: 50,
                            prediction: .heads
                        ),
                        Bet(
                            id: UUID(),
                            amount: 30,
                            prediction: .tails
                        ),
                        Bet(
                            id: UUID(),
                            amount: 12.50,
                            prediction: .heads
                        ),
                    ]
                ),
            ]
        )
    }

    private func sessionWithBettingStartInThePast() -> Session {
        Session(
            id: UUID(),
            name: "Anzac Day 2000",
            date: baseDate,
            year: 2000,
            rounds: []
        )
    }
}
