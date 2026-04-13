import SwiftUI

/// Placeholder UI for empty sessions and similar empty lists (PRD edge cases).
struct EmptyState: View {
    let title: String
    var message: String?
    var systemImage: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            VStack(spacing: DesignTokens.Spacing.large) {
                Image(systemName: systemImage)
                    .font(.system(size: 44))
                    .foregroundStyle(.secondary)
                    .symbolRenderingMode(.hierarchical)
                VStack(spacing: DesignTokens.Spacing.small) {
                    Text(title)
                        .font(DesignTokens.Typography.sectionTitle)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    if let message {
                        Text(message)
                            .font(DesignTokens.Typography.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, .margin)
            Spacer(minLength: 0)
        }
        .skip_accessibilityElement(children: .combine)
    }
}

#if !os(Android)
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
#endif
