import ASKCoordinator
import Knit
import SwiftUI

extension CoordinatorView {
    func withRenderers(resolver: Resolver) -> Self {
        self.with(renderer: resolver.mainPathRenderer())
            .with(overlay: .card) { view, _ in
                AnyView(CardPathWrapper { view })
            }
    }
}
