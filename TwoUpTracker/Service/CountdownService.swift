import Foundation

@MainActor
final class CountdownService: ObservableObject {

    private var timer: Timer?
    private let nowProvider: () -> Date
    private let mainStore: MainStore

    @Published var countdownFinished: Bool = false

    init(
        mainStore: MainStore,
        nowProvider: @escaping () -> Date = Date.init
    ) {
        self.nowProvider = nowProvider
        self.mainStore = mainStore
    }

    var targetDate: Date { mainStore.activeSession.bettingStartTime }

    var remainingTime: TimeInterval {
        return max(0, targetDate.timeIntervalSince(nowProvider()))
    }

    func startCountdown() {
        stopCountdown()
        checkTimer()
        guard !countdownFinished else { return }

        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkTimer()
            }
        }
        timer.tolerance = 0.1
        self.timer = timer
    }

    private func checkTimer() {
        guard !countdownFinished else { return }
        if self.remainingTime <= 0 {
            self.countdownFinished = true
            self.stopCountdown()
        }
    }

    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }

}
