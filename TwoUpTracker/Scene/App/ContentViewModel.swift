import ASKCoordinator
import Knit
import Observation

enum ContentTab: Hashable {
    /// Record a new toss and bets.
    case addRound
    /// Past rounds and running balance.
    case history
    case graph
}

@MainActor
@Observable
final class ContentViewModel {

    var selectedTab: ContentTab = .addRound

    init() {}
}
