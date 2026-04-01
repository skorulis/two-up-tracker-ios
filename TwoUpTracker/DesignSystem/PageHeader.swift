import SwiftUI

/// Standard page-level header used instead of navigation bar titles.
struct PageHeader: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text(title)
                .font(DesignTokens.Typography.display)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#if !os(Android)
#Preview {
    PageHeader(title: "Settings")
        .padding()
        .background(Colors.groupedBackground)
}
#endif
