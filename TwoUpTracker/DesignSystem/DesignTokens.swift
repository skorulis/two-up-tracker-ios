import SwiftUI

/// Shared layout and typography tokens. Prefer these over magic numbers in feature views.
enum DesignTokens {
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
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
        static let title = Font.title2.weight(.semibold)
        static let headline = Font.headline
        static let body = Font.body
        static let caption = Font.caption
        static let statValue = Font.title3.monospacedDigit()
    }
}
