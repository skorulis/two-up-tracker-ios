import SwiftUI

/// Shared top-level page container with standard spacing and background.
struct PageLayout<Header: View, Content: View>: View {
    @ViewBuilder private let header: () -> Header
    @ViewBuilder private let content: () -> Content

    init(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.medium) {
            header()
                .padding(.horizontal, .margin)
            content()
        }
        .padding(.top, DesignTokens.Spacing.medium)
        .background(Colors.groupedBackground.ignoresSafeArea())
    }
}

#Preview {
    PageLayout {
        PageHeader(title: "Preview")
    } content: {
        Card {
            Text("Content goes here")
                .font(DesignTokens.Typography.body)
        }
    }
}
