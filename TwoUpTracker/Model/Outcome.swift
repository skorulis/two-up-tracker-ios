import Foundation

/// Coin toss result for a round (`heads` / `tails`), stored as lowercase strings in JSON per PRD.
enum Outcome: String, Codable, CaseIterable, Sendable {
    case heads
    case tails
}
