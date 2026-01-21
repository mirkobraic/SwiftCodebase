import Foundation

public struct ExchangeRateModel: Sendable {

    /// Price to buy 1 base (in quote currency)
    public let ask: Decimal
    /// Price to sell 1 base (in quote currency)
    public let bid: Decimal
    public let base: Ticker
    public let quote: Ticker
    public let date: Date?
    var exchangePolicy: ExchangePolicy = .standard

    public init(ask: Decimal, bid: Decimal, base: Ticker, quote: Ticker, date: Date?) {
        self.ask = ask
        self.bid = bid
        self.base = base
        self.quote = quote
        self.date = date
    }

    /// Converts between base and quote given:
    /// - which ticker is being sold
    /// - which ticker is being bought
    /// - which side is edited (payload.ticker)
    ///
    /// Assumes:
    /// - (baseTicker, quoteTicker) describe the pair
    /// - selling and buying are one of base/quote
    /// - payload.ticker is either selling or buying ticker
    public func exchange(_ payload: ExchangePayload, selling: Ticker, buying: Ticker) -> ExchangePayload {
        guard selling != buying else { return payload }
        guard let exchangeDirection = detectExchangeDirection(selling: selling, buying: buying) else {
            // TODO: Maybe throw an error?
            return ExchangePayload(ticker: "", amount: .nan)
        }

        let exchangeCoeficient = exchangePolicy.getExchangeCoeficient(ask: ask, bid: bid, direction: exchangeDirection)

        switch payload.ticker {
        case selling:
            let baseAmount = payload.amount
            let quoteAmount = switch exchangeDirection {
            case .buyBase:
                exchangeCoeficient != 0 ? baseAmount / exchangeCoeficient : .nan
            case .sellBase:
                baseAmount * exchangeCoeficient
            }

            return ExchangePayload(ticker: buying, amount: quoteAmount)
        case buying:
            let quoteAmount = payload.amount
            let baseAmount = switch exchangeDirection {
            case .buyBase:
                quoteAmount * exchangeCoeficient
            case .sellBase:
                exchangeCoeficient != 0 ? quoteAmount / exchangeCoeficient : .nan
            }

            return ExchangePayload(ticker: selling, amount: baseAmount)
        default:
            // TODO: Maybe throw an error?
            return ExchangePayload(ticker: "", amount: .nan)
        }
    }

    public func getExchangeCoeficient(selling: Ticker, buying: Ticker) -> Decimal {
        guard let exchangeDirection = detectExchangeDirection(selling: selling, buying: buying) else { return .nan }

        return exchangePolicy.getExchangeCoeficient(ask: ask, bid: bid, direction: exchangeDirection)
    }

    private func detectExchangeDirection(selling: Ticker, buying: Ticker) -> ExchangeDirection? {
        if selling == base, buying == quote {
            return .sellBase
        } else if selling == quote, buying == base {
            return .buyBase
        } else {
            return nil
        }
    }

}
