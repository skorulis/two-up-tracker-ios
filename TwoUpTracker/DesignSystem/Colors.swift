import SwiftUI
import UIKit

/// Semantic colors aligned with PRD: system colors, clear profit vs loss.
enum Colors {
    static var profit: Color { .green }
    static var loss: Color { .red }
    static var neutral: Color { .secondary }

    static var cardBackground: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }

    static var groupedBackground: Color {
        Color(uiColor: .systemGroupedBackground)
    }
}
