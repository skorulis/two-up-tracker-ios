@testable import TwoUpTracker
import Knit
import SnapshotTesting
import SwiftUI
import Testing

@MainActor @Suite(.snapshots(record: .failed))
struct SessionDetailViewSnapshotTests {

    private let assembler = TwoUpTrackerAssembly.testing()
    private let testData = TestData()

    @Test func sessionDetailWithRealisticData() async throws {
        let viewModel = assembler.resolver.sessionDetailViewModel()
        viewModel.mainStore.activeSession = testData.realisticSession()

        let view = SessionDetailView(viewModel: viewModel)

        assertSnapshot(of: view, as: .image(on: .iPhoneSe))
    }

    @Test func sessionDetailWithRealisticDataDarkMode() async throws {
        let viewModel = assembler.resolver.sessionDetailViewModel()
        viewModel.mainStore.activeSession = testData.realisticSession()

        let view = SessionDetailView(viewModel: viewModel)

        assertSnapshot(of: view, as: .image(on: .iPhoneSe), style: .dark)
    }
}
