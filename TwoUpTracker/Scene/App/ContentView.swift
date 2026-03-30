import ASKCoordinator
import SwiftUI

struct ContentView: View {
    @Bindable var model: ContentViewModel
    @Environment(\.resolver) private var resolver

    @State private var currentoundCoordinator = Coordinator(root: MainPath.currentRound)
    @State private var historyCoordinator = Coordinator(root: MainPath.sessionDetail)

    var body: some View {
        TabView(selection: $model.selectedTab) {
            CoordinatorView(coordinator: currentoundCoordinator)
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Bets", systemImage: "plus.circle.fill")
                }
                .tag(ContentTab.currentRound)

            CoordinatorView(coordinator: historyCoordinator)
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("History", systemImage: "list.bullet.rectangle")
                }
                .tag(ContentTab.history)

            GraphView(model: resolver!.graphViewModel())
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(ContentTab.graph)

            SettingsView(model: resolver!.settingsViewModel())
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(ContentTab.settings)
        }
    }
}
