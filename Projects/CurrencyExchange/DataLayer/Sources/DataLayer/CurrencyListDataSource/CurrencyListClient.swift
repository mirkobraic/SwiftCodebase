import DomainLayer

public actor CurrencyListClient: CurrencyListDataSource {

    private let apiClient: APIClientProtocol

    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func getAvailableCurrencies() async throws -> [String] {
        try await apiClient.request(Endpoint.tickerCurrencies)
    }

}
