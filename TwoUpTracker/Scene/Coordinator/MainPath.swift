import ASKCoordinator

enum MainPath: CoordinatorPath {
    case content
    case sessionDetail
    case currentRound

    var id: String {
        switch self {
        case .content:
            "content"
        case .sessionDetail:
            "sessionDetail"
        case .currentRound:
            "currentRound"
        }
    }
}
