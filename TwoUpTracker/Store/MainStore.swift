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

    private(set) var activeSession: Session

    @Resolvable<BaseResolver>
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        if let data = keyValueStore.data(forKey: Self.activeSessionKey),
           let session = Self.decodeSession(from: data) {
            activeSession = session
        } else {
            activeSession = Self.makeDefaultSession()
            persist()
        }
    }

    func appendRound(_ round: Round) {
        activeSession.rounds.append(round)
        persist()
    }

    private func persist() {
        guard let data = Self.encodeSession(activeSession) else { return }
        keyValueStore.set(data, forKey: Self.activeSessionKey)
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

    private static func encodeSession(_ session: Session) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return try? encoder.encode(session)
    }

    private static func decodeSession(from data: Data) -> Session? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(Session.self, from: data)
    }
}
