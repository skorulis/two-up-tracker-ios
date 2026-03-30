import ASKCore
import Foundation
import Knit
import KnitMacros

final class TwoUpTrackerAssembly: AutoInitModuleAssembly {
    static var dependencies: [any Knit.ModuleAssembly.Type] { [] }
    typealias TargetResolver = BaseResolver

    private let purpose: IOCPurpose

    init() {
        self.purpose = .testing
    }

    init(purpose: IOCPurpose) {
        self.purpose = purpose
    }

    @MainActor func assemble(container: Container<TargetResolver>) {
        ASKCoreAssembly(purpose: purpose).assemble(container: container)

        registerMainPathRenderer(container: container)
        registerServices(container: container)
        registerStores(container: container)
        registerViewModels(container: container)
    }

    @MainActor
    private func registerMainPathRenderer(container: Container<TargetResolver>) {
        container.register(MainPathRenderer.self) { MainPathRenderer(resolver: $0) }
    }

    @MainActor
    private func registerServices(container: Container<TargetResolver>) {
        if purpose == .normal {
            container.register(AnalyticsService.self) { AmplitudeAnalyticsService.make(resolver: $0) }
                .inObjectScope(.container)
        } else {
            // @knit ignore
            container.register(AnalyticsService.self) { _ in FakeAnalyticsService() }
                .inObjectScope(.container)
        }
    }

    @MainActor
    private func registerStores(container: Container<TargetResolver>) {
        container.register(MainStore.self) { MainStore.make(resolver: $0) }
            .inObjectScope(.container)
    }

    @MainActor
    private func registerViewModels(container: Container<TargetResolver>) {
        container.register(ContentViewModel.self) { ContentViewModel.make(resolver: $0) }
        container.register(SessionDetailViewModel.self) { SessionDetailViewModel.make(resolver: $0) }
        container.register(CurrentRoundViewModel.self) { CurrentRoundViewModel.make(resolver: $0) }
        container.register(SettingsViewModel.self) { SettingsViewModel.make(resolver: $0) }
        container.register(GraphViewModel.self) { GraphViewModel.make(resolver: $0) }
    }
}

extension TwoUpTrackerAssembly {
    @MainActor static func testing() -> ScopedModuleAssembler<BaseResolver> {
        ScopedModuleAssembler<BaseResolver>([TwoUpTrackerAssembly()])
    }
}
