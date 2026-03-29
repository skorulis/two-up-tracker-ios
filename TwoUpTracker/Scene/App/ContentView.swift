import ASKCoordinator
import SwiftUI

struct ContentView: View {
    @Bindable var model: ContentViewModel
    @Environment(\.resolver) private var resolver

    @State var sessionCoordinator = Coordinator(root: MainPath.sessionDetail)

    var body: some View {
        TabView(selection: $model.selectedTab) {
            CoordinatorView(coordinator: sessionCoordinator)
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Session", systemImage: "calendar")
                }
                .tag(ContentTab.session)

            Text("Graph")
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(ContentTab.graph)
        }
    }
}
