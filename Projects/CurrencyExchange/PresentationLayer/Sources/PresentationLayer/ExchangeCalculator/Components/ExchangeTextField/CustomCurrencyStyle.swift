import SwiftUI

struct CustomCurrencyStyle: ParseableFormatStyle {

    let symbol: String
    let maxValue: Decimal?
    let formatStyle: Decimal.FormatStyle
    let parseStrategy: CustomCurrencyStrategy

    init(symbol: String, maxValue: Decimal?) {
        self.symbol = symbol
        self.maxValue = maxValue
        formatStyle = .number.precision(.fractionLength(2))
        parseStrategy = .init(symbol: symbol, formatStyle: formatStyle)
    }

    func format(_ value: Decimal) -> String {
        let clampedValue = if let maxValue {
            max(0, min(value, maxValue))
        } else {
            value
        }
        let formatted = clampedValue.formatted(formatStyle)

        return "\(symbol)\(formatted)"
    }

}

struct CustomCurrencyStrategy: ParseStrategy {

    let symbol: String
    let formatStyle: Decimal.FormatStyle

    func parse(_ value: String) throws -> Decimal {
        let trimmedValue = value.replacing(symbol, with: "")

        return (try? Decimal(trimmedValue, format: formatStyle)) ?? 0
    }

}

extension FormatStyle where Self == CustomCurrencyStyle {

    static func customCurrency(symbol: String, maxValue: Decimal? = nil) -> CustomCurrencyStyle {
        CustomCurrencyStyle(symbol: symbol, maxValue: maxValue)
    }

}
