import ASKCoordinator

enum MainPath: CoordinatorPath {
    case content
    case sessionDetail
    case currentRound
    case settings
    case whatIsTwoUp
    case addBet((Bet) -> Void)
    case twoUpAvailabilityInfo

    var id: String {
        switch self {
        case .content:
            "content"
        case .sessionDetail:
            "sessionDetail"
        case .currentRound:
            "currentRound"
        case .settings:
            "settings"
        case .whatIsTwoUp:
            "whatIsTwoUp"
        case .addBet: "addBet"
        case .twoUpAvailabilityInfo:
            "twoUpAvailabilityInfo"
        }
    }
}
