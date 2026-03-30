@testable import TwoUpTracker
import Knit
import SnapshotTesting
import SwiftUI
import Testing

@MainActor @Suite(.snapshots(record: .failed))
struct GraphViewSnapshotTests {

    private let assembler = TwoUpTrackerAssembly.testing()
    private let testData = TestData()

    @Test func graphWithRealisticData() async throws {
        let viewModel = assembler.resolver.graphViewModel()
        viewModel.mainStore.activeSession = testData.realisticSession()

        let view = GraphView(model: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe))
    }

    @Test func graphWithRealisticDataDarkMode() async throws {
        let viewModel = assembler.resolver.graphViewModel()
        viewModel.mainStore.activeSession = testData.realisticSession()

        let view = GraphView(model: viewModel)
        assertSnapshot(of: view, as: .image(on: .iPhoneSe), style: .dark)
    }

    
}
