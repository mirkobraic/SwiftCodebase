import DomainLayer

public actor ExchangeRateClient: ExchangeRateDataSource {

    private let apiClient: APIClientProtocol

    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func getUSDcExchangeRates(for tickers: [String]) async throws -> [ExchangeRateModel] {
        let params = ExchangeRateParameters(currencies: tickers)
        let response: [ExchangeRateResponse] = try await apiClient.request(Endpoint.tickers(params: params))

        return response.compactMap { $0.toDomainModel() }
    }

}
