import Foundation

struct ExchangePolicy: Sendable {

    private let getExchangeCoeficient: @Sendable (Decimal, Decimal, ExchangeDirection) -> Decimal

    func getExchangeCoeficient(ask: Decimal, bid: Decimal, direction: ExchangeDirection) -> Decimal {
        getExchangeCoeficient(ask, bid, direction)
    }

}

extension ExchangePolicy {

    static let standard = ExchangePolicy { ask, bid, direction in
        switch direction {
        case .buyBase:
            return ask
        case .sellBase:
            return bid
        }
    }

    static let midMarket = ExchangePolicy { ask, bid, _ in
        (ask + bid) / 2
    }

    static func adjusted(feePercentage: Decimal) -> ExchangePolicy {
        assert(feePercentage >= 0 && feePercentage <= 100)

        return ExchangePolicy { ask, bid, direction in
            let fee = feePercentage / 100

            switch direction {
            case .buyBase:
                // User pays more quote for base
                return ask * (1 + fee)
            case .sellBase:
                // User gets less quote for base
                return bid * (1 - fee)
            }
        }
    }

}
