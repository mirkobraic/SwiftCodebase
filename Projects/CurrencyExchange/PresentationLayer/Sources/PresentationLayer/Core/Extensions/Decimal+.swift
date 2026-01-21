import Foundation

extension Decimal {

    var hasFraction: Bool {
        var value = self
        var roundedValue = Decimal()
        NSDecimalRound(&roundedValue, &value, 0, .down)

        return self != roundedValue
    }

    func asCurrency(currencySymbol: String) -> String {
        let formatter = NumberFormatter()
        formatter.currencySymbol = currencySymbol
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = self.hasFraction ? 2 : 0
        formatter.maximumFractionDigits = 2

        return formatter.string(for: self) ?? self.description
    }

    var roundedAsCurrency: Self {
        var value = self
        var result = Decimal()
        NSDecimalRound(&result, &value, 2, .plain)

        return result
    }

}
