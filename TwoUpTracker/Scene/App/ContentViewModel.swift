import ASKCoordinator
import Knit
import KnitMacros
import Observation

enum ContentTab: Hashable {
    /// Enter outstanding bets for a round (toss recorded later from History).
    case currentRound
    /// Past rounds and running balance.
    case history
    case graph
    case settings
}

@MainActor
@Observable
final class ContentViewModel {
    private let analyticsService: AnalyticsService

    @ObservationIgnored var selectedTab: ContentTab = .currentRound {
        didSet {
            guard selectedTab != oldValue else { return }
            analyticsService.viewScreen(name: Self.viewName(for: selectedTab))
        }
    }

    @Resolvable<BaseResolver>
    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
        // Fire the initial tab impression so analytics reflects the first screen.
        self.analyticsService.viewScreen(name: Self.viewName(for: selectedTab))
    }

    private static func viewName(for tab: ContentTab) -> String {
        switch tab {
        case .currentRound: return "Bets"
        case .history: return "History"
        case .graph: return "Graph"
        case .settings: return "Settings"
        }
    }
}
