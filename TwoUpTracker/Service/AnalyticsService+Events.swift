//  Created by Alex Skorulis on 31/3/2026.

import Foundation

extension AnalyticsService {
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
