import Foundation
import Testing
@testable import DomainLayer

@Suite("ExchangePolicy Tests")
struct ExchangePolicyTests {

    private let ask: Decimal = 3
    private let bid: Decimal = 2

    @Test
    func `standard policy uses ask when buying base`() {
        let coef = ExchangePolicy.standard.getExchangeCoeficient(ask: ask, bid: bid, direction: .buyBase)
        #expect(coef == ask)
    }

    @Test
    func `standard policy uses bid when selling base`() {
        let coef = ExchangePolicy.standard.getExchangeCoeficient(ask: ask, bid: bid, direction: .sellBase)
        #expect(coef == bid)
    }

    @Test
    func `midMarket policy averages ask and bid regardless of direction`() {
        let expected = (ask + bid) / 2
        let coefBuy = ExchangePolicy.midMarket.getExchangeCoeficient(ask: ask, bid: bid, direction: .buyBase)
        let coefSell = ExchangePolicy.midMarket.getExchangeCoeficient(ask: ask, bid: bid, direction: .sellBase)
        #expect(coefBuy == expected)
        #expect(coefSell == expected)
    }

    @Test
    func `adjusted policy increases ask when buying base by fee percent`() {
        let fee: Decimal = 10 // 10%
        let policy = ExchangePolicy.adjusted(feePercentage: fee)
        let coef = policy.getExchangeCoeficient(ask: ask, bid: bid, direction: .buyBase)
        #expect(coef == ask * (1 + fee / 100))
    }

    @Test
    func `adjusted policy decreases bid when selling base by fee percent`() {
        let fee: Decimal = 10 // 10%
        let policy = ExchangePolicy.adjusted(feePercentage: fee)
        let coef = policy.getExchangeCoeficient(ask: ask, bid: bid, direction: .sellBase)
        #expect(coef == bid * (1 - fee / 100))
    }

    @Test
    func `adjusted policy handles 0 percent fee`() {
        let fee: Decimal = 0
        let policy = ExchangePolicy.adjusted(feePercentage: fee)
        let coefBuy = policy.getExchangeCoeficient(ask: ask, bid: bid, direction: .buyBase)
        let coefSell = policy.getExchangeCoeficient(ask: ask, bid: bid, direction: .sellBase)
        #expect(coefBuy == ask)
        #expect(coefSell == bid)
    }

    @Test
    func `adjusted policy handles 100 percent fee`() {
        let fee: Decimal = 100
        let policy = ExchangePolicy.adjusted(feePercentage: fee)
        let coefBuy = policy.getExchangeCoeficient(ask: ask, bid: bid, direction: .buyBase)
        let coefSell = policy.getExchangeCoeficient(ask: ask, bid: bid, direction: .sellBase)
        #expect(coefBuy == ask * 2)     // 1 + 100% = 2x
        #expect(coefSell == 0)          // 1 - 100% = 0
    }
}



