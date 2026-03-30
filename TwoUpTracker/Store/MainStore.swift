import ASKCore
import Foundation
import Knit
import KnitMacros
import Observation

/// App data store: active session persisted via `PKeyValueStore`.
@MainActor
final class MainStore: ObservableObject {
    private let keyValueStore: PKeyValueStore

    private static let activeSessionKey = "twoUpTracker.sessions.v1"
    private static let appSettingsKey = "twoUpTracker.appSettings.v1"
    private static let userInfoKey = "twoUpTracker.userInfo.v1"

    @Published var activeSession: Session {
        didSet {
            try? keyValueStore.set(codable: activeSession, forKey: Self.activeSessionKey)
        }
    }

    @Published private(set) var settings: Settings {
        didSet {
            try? keyValueStore.set(codable: settings, forKey: Self.appSettingsKey)
        }
    }

    @Published var userInfo: UserInfo {
        didSet {
            try? keyValueStore.set(codable: userInfo, forKey: Self.userInfoKey)
        }
    }

    @Resolvable<BaseResolver>
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        activeSession = (try? keyValueStore.codable(forKey: Self.activeSessionKey)) ?? .defaultSession()
        settings = (try? keyValueStore.codable(forKey: Self.appSettingsKey)) ?? .init()
        if let existingUser: UserInfo = (try? keyValueStore.codable(forKey: Self.userInfoKey)) {
            self.userInfo = existingUser
        } else {
            self.userInfo = UserInfo()
            try? keyValueStore.set(codable: userInfo, forKey: Self.userInfoKey)
        }
    }

    func setLossLimit(_ value: Double?) {
        settings.lossLimit = value
    }

    func appendRound(_ round: Round) {
        activeSession.rounds.append(round)
    }

    func setRoundResult(roundId: UUID, result: Outcome) {
        guard let index = activeSession.rounds.firstIndex(where: { $0.id == roundId }) else { return }
        activeSession.rounds[index].result = result
    }

    func removeRound(id: UUID) {
        activeSession.rounds.removeAll { $0.id == id }
    }

    /// Clears persisted session and preferences to their default state.
    func resetAllData() {
        activeSession = .defaultSession()
        settings = .default
    }
}
