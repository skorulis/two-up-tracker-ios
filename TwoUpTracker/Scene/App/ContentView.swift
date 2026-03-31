import ASKCoordinator
import SwiftUI

struct ContentView: View {
    @State var model: ContentViewModel
    @Environment(\.resolver) private var resolver

    var body: some View {
        TabView(selection: $model.selectedTab) {
            CoordinatorView(coordinator: Coordinator(root: MainPath.currentRound))
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Bets", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                }
                .tag(ContentTab.currentRound)

            CoordinatorView(coordinator: Coordinator(root: MainPath.sessionDetail))
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("History", systemImage: "list.bullet.rectangle")
                }
                .tag(ContentTab.history)

            GraphView(viewModel: resolver!.graphViewModel())
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(ContentTab.graph)

            CoordinatorView(coordinator: Coordinator(root: MainPath.settings))
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(ContentTab.settings)
        }
    }
}
