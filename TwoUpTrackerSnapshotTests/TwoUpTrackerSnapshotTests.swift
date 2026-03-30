//  Created by Alex Skorulis on 31/3/2026.

@testable import TwoUpTracker
import Knit
import SnapshotTesting
import SwiftUI
import Testing

@MainActor @Suite(.snapshots(record: .failed))
struct SettingsViewSnapshotTests {

    private let assembler = TwoUpTrackerAssembly.testing()

    @Test func settings() async throws {
        let viewModel = assembler.resolver.settingsViewModel()
        let view = SettingsView(viewModel: viewModel)

        assertSnapshot(of: view, as: .image(on: .iPhoneSe))
    }

}
