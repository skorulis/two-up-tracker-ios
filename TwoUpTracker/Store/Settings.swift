import Foundation

/// User preferences persisted with the app (see `MainStore`).
struct Settings: Codable, Equatable, Sendable {
    /// Maximum session loss (positive dollars) before the user considers stopping; `nil` means no limit.
    var lossLimit: Double?

    static let `default` = Settings(lossLimit: nil)
}
