import ASKCoordinator
import SwiftUI

struct ContentView: View {
    @Bindable var model: ContentViewModel
    @Environment(\.resolver) private var resolver

    @State private var addRoundCoordinator = Coordinator(root: MainPath.addRound)
    @State private var historyCoordinator = Coordinator(root: MainPath.sessionDetail)

    var body: some View {
        TabView(selection: $model.selectedTab) {
            CoordinatorView(coordinator: addRoundCoordinator)
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .tag(ContentTab.addRound)

            CoordinatorView(coordinator: historyCoordinator)
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("History", systemImage: "list.bullet.rectangle")
                }
                .tag(ContentTab.history)

            Text("Graph")
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(ContentTab.graph)
        }
    }
}
