//  Created by Alex Skorulis on 31/3/2026.

import Foundation
import SwiftUI

extension DesignTokens {
    enum Typography {
        static let display = Font.custom(Family.headingBold, size: 34, relativeTo: .largeTitle)
        static let sectionTitle = Font.custom(Family.headingSemibold, size: 22, relativeTo: .title2)
        static let buttonLabel = Font.custom(Family.headingSemibold, size: 17, relativeTo: .headline)
        static let body = Font.custom(Family.body, size: 17, relativeTo: .body)
        static let bodyStrong = Font.custom(Family.bodySemibold, size: 17, relativeTo: .body)
        static let caption = Font.custom(Family.heading, size: 13, relativeTo: .caption)
        static let statValue = Font.custom(Family.headingSemibold, size: 20, relativeTo: .title3).monospacedDigit()
        /// Large currency figure for emphasis (e.g. pending round total staked).
        static let heroValue = Font.custom(Family.headingBold, size: 52, relativeTo: .largeTitle)
    }
}

extension DesignTokens.Typography {
    /// WW2-inspired typography:
    /// - Gill Sans for headings/labels (official Commonwealth document feel)
    /// - Baskerville for longer reading text (historical print tone)
    private enum Family {
        static let heading = "GillSans"
        static let headingSemibold = "GillSans-SemiBold"
        static let headingBold = "GillSans-Bold"
        static let body = "Helvetica"
        static let bodySemibold = "Helvetica-SemiBold"
    }
}

private struct TypographyCatalog: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.large) {
                row("display", DesignTokens.Typography.display, "Two-up Tracker")
                row("sectionTitle", DesignTokens.Typography.sectionTitle, "Round history")
                row("buttonLabel", DesignTokens.Typography.buttonLabel, "Place bet")
                row(
                    "body",
                    DesignTokens.Typography.body,
                    "Body text for longer passages and supporting copy."
                )
                row(
                    "bodyStrong",
                    DesignTokens.Typography.bodyStrong,
                    "Emphasised body when you need a bit more weight."
                )
                row("caption", DesignTokens.Typography.caption, "Captions, hints, and secondary labels")
                row("statValue", DesignTokens.Typography.statValue, "$12,340.56 · 47 heads")
                row("heroValue", DesignTokens.Typography.heroValue, "$1,234")
            }
            .padding(DesignTokens.Spacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Colors.groupedBackground)
    }

    private func row(_ name: String, _ font: Font, _ sample: String) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text(name)
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
            Text(sample)
                .font(font)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview("Typography") {
    TypographyCatalog()
}
