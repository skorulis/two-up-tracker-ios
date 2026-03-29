import ASKCore
import Foundation
import Knit
import KnitMacros
import Observation

/// App data store: active session persisted via `PKeyValueStore`.
@MainActor
@Observable
final class MainStore {
    private let keyValueStore: PKeyValueStore

    private static let activeSessionKey = "twoUpTracker.sessions.v1"
    private static let appSettingsKey = "twoUpTracker.appSettings.v1"

    private(set) var activeSession: Session {
        didSet {
            try? keyValueStore.set(codable: activeSession, forKey: Self.activeSessionKey)
        }
    }

    private(set) var settings: Settings {
        didSet {
            try? keyValueStore.set(settings, forKey: Self.appSettingsKey)
        }
    }

    @Resolvable<BaseResolver>
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        activeSession = (try? keyValueStore.codable(forKey: Self.activeSessionKey)) ?? Self.makeDefaultSession()
        settings = (try? keyValueStore.codable(forKey: Self.appSettingsKey)) ?? .init()
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

    private static func makeDefaultSession() -> Session {
        let year = Calendar.current.component(.year, from: Date())
        return Session(
            id: UUID(),
            name: "Anzac Day \(year)",
            date: Date(),
            rounds: []
        )
    }
}
