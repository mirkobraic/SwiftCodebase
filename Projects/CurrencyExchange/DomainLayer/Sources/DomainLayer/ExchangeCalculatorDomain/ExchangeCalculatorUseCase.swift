public actor ExchangeCalculatorUseCase: ExchangeCalculatorUseCaseProtocol {

    private let dataSource: ExchangeRateDataSource

    public init(dataSource: ExchangeRateDataSource) {
        self.dataSource = dataSource
    }

    public func getUSDcExchangeRates(for tickers: [String]) async throws -> [ExchangeRateModel] {
        try await dataSource.getUSDcExchangeRates(for: tickers)
    }

    public func getUSDcExchangeRate(for ticker: String) async throws -> ExchangeRateModel {
        let exchangeRates = try await dataSource.getUSDcExchangeRates(for: [ticker])

        guard var requestedExchangeRate = exchangeRates.first else {
            throw ExchangeRateError.rateNotFound
        }

        requestedExchangeRate.exchangePolicy = .adjusted(feePercentage: 10)

        return requestedExchangeRate
    }

    public func getUSDcExchangeRateStream(for ticker: String) async throws -> AsyncStream<ExchangeRateModel> {
        // TODO: AsyncStream (or Combine) should be used to ensure we don't have stale exchange rates.
        fatalError("Unimplemented")
    }

}
