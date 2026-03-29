import ASKCore
import Foundation
import Knit
import KnitMacros
import Observation

/// App data store: sessions persisted via `PKeyValueStore` (UserDefaults in production, in-memory in tests).
@MainActor final class MainStore: ObservableObject {
    private let keyValueStore: PKeyValueStore

    private static let activeSessionKey = "twoUpTracker.sessions.v1"

    @Published var activeSession: Session {
        didSet {
            try? keyValueStore.set(codable: activeSession, forKey: Self.activeSessionKey)
        }
    }

    @Resolvable<BaseResolver>
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        activeSession = (try? keyValueStore.codable(forKey: Self.activeSessionKey)) ?? Self.makeDefaultSession()
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
