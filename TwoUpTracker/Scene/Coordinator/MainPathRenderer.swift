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
                    store: resolver.mainStore()
                )
            )
        case .addRound:
            AnyView(
                AddRoundView(
                    model: AddRoundViewModel.make(resolver: resolver),
                    store: resolver.mainStore()
                )
            )
        }
    }
}
