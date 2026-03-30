import Foundation
import SwiftUI

/// Coin toss result for a round (`heads` / `tails`), stored as lowercase strings in JSON per PRD.
enum Outcome: String, Codable, CaseIterable, Sendable {
    case heads
    case tails
    
    var borderColor: Color {
        switch self {
        case .heads:
            return Colors.australianGreen
        case .tails:
            return Colors.australianGold
        }
    }
}
