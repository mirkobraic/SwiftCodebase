public protocol ExchangeCalculatorUseCaseProtocol: Actor {

    func getUSDcExchangeRates(for tickers: [String]) async throws -> [ExchangeRateModel]

    func getUSDcExchangeRate(for ticker: String) async throws -> ExchangeRateModel

    func getUSDcExchangeRateStream(for ticker: String) async throws -> AsyncStream<ExchangeRateModel>

}
