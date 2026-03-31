import ASKCoordinator
import Knit
import SwiftUI

struct MainPathRenderer: CoordinatorPathRenderer {
    typealias PathType = MainPath

    let resolver: BaseResolver

    @ViewBuilder @MainActor
    func render(path: MainPath, in coordinator: Coordinator) -> some View {
        switch path {
        case .content:
            ContentView(model: resolver.contentViewModel())
        case .sessionDetail:
            SessionDetailView(viewModel: resolver.sessionDetailViewModel())
        case .currentRound:
            CurrentRoundView(viewModel: coordinator.apply(resolver.currentRoundViewModel()))
        case .settings:
            SettingsView(viewModel: coordinator.apply(resolver.settingsViewModel()))
        case .whatIsTwoUp:
            WhatIsTwoUpView(coordinator: coordinator)
        case let .addBet(onSetBet):
            AddBetView(isCustomAmountFieldFocused: .constant(false), onSetBet: onSetBet)
        case .twoUpAvailabilityInfo:
            TwoUpAvailabilityInfoView()
        }
    }
}
