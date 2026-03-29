import ASKCoordinator
import Knit
import SwiftUI

extension CoordinatorView {
    func withRenderers(resolver: BaseResolver) -> Self {
        self.with(renderer: resolver.mainPathRenderer())
    }
}
