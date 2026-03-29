import ASKCoordinator
import Knit
import SwiftUI

struct MainPathRenderer: CoordinatorPathRenderer {
    typealias PathType = MainPath
    typealias ViewType = ContentView

    let resolver: BaseResolver

    @MainActor
    func render(path: MainPath, in coordinator: Coordinator) -> ContentView {
        switch path {
        case .content:
            ContentView(model: ContentViewModel.make(resolver: resolver))
        }
    }
}
