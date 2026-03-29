import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .foregroundStyle(.primary)
            if let subtitle {
                Text(subtitle)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("With subtitle") {
    SectionHeader(title: "Statistics", subtitle: "Current session")
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Colors.groupedBackground)
}

#Preview("Title only") {
    SectionHeader(title: "Rounds")
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Colors.groupedBackground)
}
