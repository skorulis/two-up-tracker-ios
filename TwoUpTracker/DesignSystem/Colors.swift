import SwiftUI
import UIKit

/// Semantic colors aligned with PRD: system colors, clear profit vs loss.
enum Colors {
    static var profit: Color { australianGreen }
    static var loss: Color { .red }
    static var neutral: Color { .secondary }

    static var cardBackground: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }

    static var groupedBackground: Color {
        Color(uiColor: .systemGroupedBackground)
    }

    // MARK: - Australian national colours
    // Reference: Pantone 348 C and 116 C (Australian Government); common sRGB approximations #00843D / #FFCD00.

    /// Australian national green (Pantone 348 C, sRGB `#00843D`).
    static let australianGreen = Color(red: 0, green: 132.0 / 255, blue: 61.0 / 255)

    /// Australian national gold (Pantone 116 C, sRGB `#FFCD00`).
    static let australianGold = Color(red: 1, green: 205.0 / 255, blue: 0)
}
