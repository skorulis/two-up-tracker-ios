//  Created by Alex Skorulis on 31/3/2026.

import Foundation

enum Formatters {
    private static var currencyCode: String { "AUD" }

    /// Whole dollars without “.00”; cents shown when needed (e.g. $10.50).
    static var currencyDisplayFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: currencyCode).precision(.fractionLength(0...2))
    }

    static var roundedCurrencyDisplayFormat: FloatingPointFormatStyle<Double>.Currency {
        .currency(code: currencyCode).precision(.fractionLength(0))
    }
}
