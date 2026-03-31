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
                SessionDetailView(viewModel: resolver.sessionDetailViewModel())
            )
        case .currentRound:
            AnyView(
                CurrentRoundView(viewModel: coordinator.apply(resolver.currentRoundViewModel()))
            )
        case .settings:
            AnyView(SettingsView(viewModel: coordinator.apply(resolver.settingsViewModel())))
        case .whatIsTwoUp:
            AnyView(WhatIsTwoUpView(coordinator: coordinator))
        case let .addBet(onSetBet):
            AnyView(AddBetView(onSetBet: onSetBet))
        case .twoUpAvailabilityInfo:
            AnyView(TwoUpAvailabilityInfoView())
        }
    }
}
