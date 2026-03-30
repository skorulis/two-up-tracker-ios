import SwiftUI

/// Shared layout and typography tokens. Prefer these over magic numbers in feature views.
enum DesignTokens {
    enum Spacing {
        static let xs: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum CornerRadius {
        static let card: CGFloat = 12
        static let button: CGFloat = 12
        static let chip: CGFloat = 8
    }

    enum MinTapTarget {
        static let height: CGFloat = 44
    }

    enum Typography {
        /// WW2-inspired typography:
        /// - Gill Sans for headings/labels (official Commonwealth document feel)
        /// - Baskerville for longer reading text (historical print tone)
        private enum Family {
            static let heading = "GillSans"
            static let headingSemibold = "GillSans-SemiBold"
            static let headingBold = "GillSans-Bold"
            static let body = "Baskerville"
            static let bodySemibold = "Baskerville-SemiBold"
        }

        // Core semantic scale
        static let display = Font.custom(Family.headingBold, size: 34, relativeTo: .largeTitle)
        static let sectionTitle = Font.custom(Family.headingSemibold, size: 22, relativeTo: .title2)
        static let buttonLabel = Font.custom(Family.headingSemibold, size: 17, relativeTo: .headline)
        static let bodyPrimary = Font.custom(Family.body, size: 17, relativeTo: .body)
        static let bodyStrong = Font.custom(Family.bodySemibold, size: 17, relativeTo: .body)
        static let captionSmall = Font.custom(Family.heading, size: 13, relativeTo: .caption)
        static let value = Font.custom(Family.headingSemibold, size: 20, relativeTo: .title3).monospacedDigit()

        // Backward-compatible aliases used by existing views
        static let title = sectionTitle
        static let headline = buttonLabel
        static let body = bodyPrimary
        static let caption = captionSmall
        static let statValue = value
    }
}
