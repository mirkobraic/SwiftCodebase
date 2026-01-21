import Foundation
import Testing
@testable import DomainLayer

@Suite("ExchangeRateModel Tests")
struct ExchangeRateModelTests {

    private func makeModel(
        ask: Decimal = 3,
        bid: Decimal = 2,
        base: Ticker = "usdc",
        quote: Ticker = "ars",
        policy: ExchangePolicy = .standard
    ) -> ExchangeRateModel {
        var model = ExchangeRateModel(ask: ask, bid: bid, base: base, quote: quote, date: nil)
        model.exchangePolicy = policy
        return model
    }

    // MARK: - Coefficient selection

    @Test
    func `coefficient uses bid when selling base`() {
        let model = makeModel()
        let coef = model.getExchangeCoeficient(selling: "usdc", buying: "ars")
        #expect(coef == 2)
    }

    @Test
    func `coefficient uses ask when buying base`() {
        let model = makeModel()
        let coef = model.getExchangeCoeficient(selling: "ars", buying: "usdc")
        #expect(coef == 3)
    }

    @Test
    func `midMarket coefficient averages ask and bid`() {
        let model = makeModel(policy: .midMarket)
        let coefSellBase = model.getExchangeCoeficient(selling: "usdc", buying: "ars")
        let coefBuyBase = model.getExchangeCoeficient(selling: "ars", buying: "usdc")
        #expect(coefSellBase == 2.5)
        #expect(coefBuyBase == 2.5)
    }

    @Test
    func `adjusted coefficient applies fee to ask and bid`() {
        let model = makeModel(policy: .adjusted(feePercentage: 10))
        let coefSellBase = model.getExchangeCoeficient(selling: "usdc", buying: "ars")
        let coefBuyBase = model.getExchangeCoeficient(selling: "ars", buying: "usdc")
        #expect(coefSellBase == 2 * (1 - 0.1))
        #expect(coefBuyBase == 3 * (1 + 0.1))
    }

    // MARK: - Exchange conversions (editing selling side)

    @Test
    func `selling base converts to quote using bid`() {
        let model = makeModel()
        let payload = ExchangePayload(ticker: "usdc", amount: 10)
        let result = model.exchange(payload, selling: "usdc", buying: "ars")
        #expect(result.ticker == "ars")
        #expect(result.amount == 20)
    }

    @Test
    func `selling quote converts to base using ask`() {
        let model = makeModel()
        let payload = ExchangePayload(ticker: "ars", amount: 9)
        let result = model.exchange(payload, selling: "ars", buying: "usdc")
        #expect(result.ticker == "usdc")
        #expect(result.amount == 3)
    }

    // MARK: - Exchange conversions (editing buying side)

    @Test
    func `editing buying base computes selling quote using ask`() {
        let model = makeModel()
        let desiredBuying = ExchangePayload(ticker: "usdc", amount: 5) // want 5 base
        let result = model.exchange(desiredBuying, selling: "ars", buying: "usdc")
        #expect(result.ticker == "ars") // amount to sell
        #expect(result.amount == 15)
    }

    @Test
    func `editing buying quote computes selling base using bid`() {
        let model = makeModel()
        let desiredBuying = ExchangePayload(ticker: "ars", amount: 8) // want 8 quote
        let result = model.exchange(desiredBuying, selling: "usdc", buying: "ars")
        #expect(result.ticker == "usdc") // amount to sell
        #expect(result.amount == 4)
    }

    // MARK: - Round-trip consistency

    @Test
    func `round trip selling base -> buying quote -> back preserves amount`() {
        let model = makeModel()
        let original = Decimal(12)
        let sellPayload = ExchangePayload(ticker: "usdc", amount: original)
        let toQuote = model.exchange(sellPayload, selling: "usdc", buying: "ars")
        let backToBase = model.exchange(ExchangePayload(ticker: "ars", amount: toQuote.amount), selling: "usdc", buying: "ars")
        #expect(backToBase.amount == original)
    }

    @Test
    func `round trip selling quote -> buying base -> back preserves amount`() {
        let model = makeModel()
        let original = Decimal(15)
        let sellPayload = ExchangePayload(ticker: "ars", amount: original)
        let toBase = model.exchange(sellPayload, selling: "ars", buying: "usdc")
        let backToQuote = model.exchange(ExchangePayload(ticker: "usdc", amount: toBase.amount), selling: "ars", buying: "usdc")
        #expect(backToQuote.amount == original)
    }

    // MARK: - Edge cases

    @Test
    func `selling and buying same ticker returns payload unchanged`() {
        let model = makeModel()
        let payload = ExchangePayload(ticker: "usdc", amount: 7)
        let result = model.exchange(payload, selling: "usdc", buying: "usdc")
        #expect(result.ticker == payload.ticker)
        #expect(result.amount == payload.amount)
    }

    @Test
    func `invalid pair returns NaN and empty ticker`() {
        var model = makeModel()
        // Change model pair so that selling/buying are unrelated to model base/quote
        model = makeModel(base: "btc", quote: "eth")
        let payload = ExchangePayload(ticker: "usdc", amount: 1)
        let result = model.exchange(payload, selling: "usdc", buying: "ars")
        #expect(result.ticker.description.isEmpty)
        #expect(result.amount.isNaN)
    }

    @Test
    func `zero coefficients yield NaN for divisions`() {
        // Use adjusted policy to force zero bid; with 100% fee, bid becomes 0
        let model = makeModel(policy: .adjusted(feePercentage: 100))
        // Selling base and editing buying side: base amount = quote / bid -> should be NaN when bid=0
        let buyingPayload = ExchangePayload(ticker: "ars", amount: 10)
        let result = model.exchange(buyingPayload, selling: "usdc", buying: "ars")
        #expect(result.amount.isNaN)
    }
}


