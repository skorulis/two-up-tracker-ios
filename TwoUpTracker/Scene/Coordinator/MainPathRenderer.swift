import ASKCoordinator
import Knit
import SwiftUI

struct MainPathRenderer: CoordinatorPathRenderer {
    typealias PathType = MainPath
    typealias ViewType = AnyView

    let resolver: BaseResolver

    @MainActor
    func render(path: MainPath, in coordinator: Coordinator) -> AnyView {
        switch path {
        case .content:
            AnyView(ContentView(model: resolver.contentViewModel()))
        case .sessionDetail:
            AnyView(
                SessionDetailView(
                    model: SessionDetailViewModel.make(resolver: resolver),
                )
            )
        case .currentRound:
            AnyView(
                CurrentRoundView(viewModel: coordinator.apply(AddRoundViewModel.make(resolver: resolver)))
            )
        case let .addBet(onSetBet):
            AnyView(AddBetView(onSetBet: onSetBet))
        }
    }
}
