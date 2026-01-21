import Foundation

public struct ExchangePayload {

    public let ticker: Ticker
    public let amount: Decimal

}

extension ExchangePayload {

    public init (ticker: String, amount: Decimal) {
        self.ticker = .init(ticker)
        self.amount = amount
    }

}
