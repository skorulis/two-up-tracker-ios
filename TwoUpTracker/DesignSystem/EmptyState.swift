import SwiftUI

/// Placeholder UI for empty sessions and similar empty lists (PRD edge cases).
struct EmptyState: View {
    let title: String
    var message: String?
    var systemImage: String

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            if let message {
                Text(message)
            }
        }
        .padding(.horizontal, .margin)
    }
}

#Preview("With message") {
    EmptyState(
        title: "No rounds yet",
        message: "Add a round to start tracking performance.",
        systemImage: "list.bullet.rectangle"
    )
}

#Preview("Title only") {
    EmptyState(title: "No sessions", systemImage: "calendar")
}
