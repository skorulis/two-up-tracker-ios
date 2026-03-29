import Knit
import KnitMacros
import Observation

@Observable
final class ContentViewModel {
    var title: String

    @Resolvable<BaseResolver>
    init() {
        title = "TwoUpTracker"
    }

    func refreshTitle() {
        title = "TwoUpTracker (updated)"
    }
}
