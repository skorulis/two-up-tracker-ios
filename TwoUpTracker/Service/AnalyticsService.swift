//
// Created by Alexander Skorulis on 22/3/2026.
//

import Foundation
import Knit
import KnitMacros
import AmplitudeUnified

protocol AnalyticsService {
    func track(event name: String, properties: [String: Any]?)
}

extension AnalyticsService {
    func track(event name: String) {
        self.track(event: name, properties: nil)
    }

    func viewScreen(name: String) {
        self.track(event: "view-screen-\(name)")
    }

    func trackBetSet() {
        self.track(event: "bet-set")
    }

    func trackBetResultConfirmed() {
        self.track(event: "bet-result-confirmed")
    }

    func trackBetReset() {
        self.track(event: "bet-reset")
    }

    func trackBetResultSetFromSessionDetails() {
        self.track(event: "bet-result-confirmed-from-session-details")
    }
}

final class AmplitudeAnalyticsService: AnalyticsService {

    private let amplitude: Amplitude

    @Resolvable<BaseResolver>
    init(mainStore: MainStore) {
        self.amplitude = Amplitude(apiKey: AppEnvironment.amplitudeKey)
        self.amplitude.setUserId(userId: UUID().uuidString)
    }

    func track(event name: String, properties: [String: Any]? = nil) {
        amplitude.track(eventType: name, eventProperties: properties)
        print("#ANALYTICS# Tracked: \(name)")
    }
}

final class FakeAnalyticsService: AnalyticsService {
    var events: [String] = []

    func track(event name: String, properties: [String: Any]? = nil) {
        events.append(name)
    }
}
