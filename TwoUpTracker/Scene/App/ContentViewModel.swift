import ASKCoordinator
import Knit
import Observation

enum ContentTab: Hashable {
    case session
    case graph
}

@MainActor
@Observable
final class ContentViewModel {

    var selectedTab: ContentTab = .session

    init() {}
}
