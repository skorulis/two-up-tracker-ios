import ASKCoordinator
import Foundation
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class SettingsViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    private let mainStore: MainStore

    /// Editable text for loss limit (currency); empty means no limit.
    var lossLimitText: String

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
        if let limit = mainStore.settings.lossLimit {
            lossLimitText = Self.formatAmount(limit)
        } else {
            lossLimitText = ""
        }
    }

    func syncFromStore() {
        if let limit = mainStore.settings.lossLimit {
            lossLimitText = Self.formatAmount(limit)
        } else {
            lossLimitText = ""
        }
    }

    func resetAllData() {
        mainStore.resetAllData()
        syncFromStore()
    }

    func showWhatIsTwoUp() {
        coordinator?.push(MainPath.whatIsTwoUp)
    }

    func showAbout() {
        coordinator?.push(MainPath.about)
    }
    
    func configureScreenshotData() {
        mainStore.activeSession = TestData().realisticSession()
    }

    func applyLossLimitFromField() {
        let trimmed = lossLimitText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            mainStore.setLossLimit(nil)
            return
        }
        guard let value = Double(trimmed.replacingOccurrences(of: ",", with: "")), value > 0 else {
            return
        }
        mainStore.setLossLimit(value)
        lossLimitText = Self.formatAmount(value)
    }

    private static func formatAmount(_ value: Double) -> String {
        if value == floor(value) {
            return String(format: "%.0f", value)
        }
        return String(value)
    }
}
