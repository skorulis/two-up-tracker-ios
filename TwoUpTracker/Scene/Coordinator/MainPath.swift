import ASKCoordinator

enum MainPath: CoordinatorPath {
    case content
    case sessionDetail
    case addRound

    var id: String {
        switch self {
        case .content:
            "content"
        case .sessionDetail:
            "sessionDetail"
        case .addRound:
            "addRound"
        }
    }
}
