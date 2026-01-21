public protocol ExchangeRateDataSource: Actor {

    func getUSDcExchangeRates(for tickers: [String]) async throws -> [ExchangeRateModel]

}
