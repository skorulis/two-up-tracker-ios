import ASKCoordinator
import Knit
import Observation

enum ContentTab: Hashable {
    /// Enter outstanding bets for a round (toss recorded later from History).
    case addRound
    /// Past rounds and running balance.
    case history
    case graph
    case settings
}

@MainActor
@Observable
final class ContentViewModel {

    var selectedTab: ContentTab = .addRound

    init() {}
}
