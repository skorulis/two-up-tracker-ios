import ASKCoordinator
import Knit
import SwiftUI

@main
struct TwoUpTrackerApp: App {
    private let assembler: ScopedModuleAssembler<Resolver> = {
        let assembler = ScopedModuleAssembler<Resolver>(
            [
                TwoUpTrackerAssembly(purpose: .normal)
            ]
        )
        return assembler
    }()

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.isRunningTests {
                Color.clear
            } else {
                CoordinatorView(coordinator: Coordinator(root: MainPath.content))
                    .withRenderers(resolver: assembler.resolver)
                    .environment(\.resolver, assembler.resolver)
            }
        }
    }
}

private extension ProcessInfo {
    static var isRunningTests: Bool {
        processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
