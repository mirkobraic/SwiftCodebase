extension CurrencyListClient {

    enum Endpoint: APIEndpoint {

        case tickerCurrencies

        var method: HTTPMethod {
            switch self {
            case .tickerCurrencies: .get
            }
        }

        var path: String {
            switch self {
            case .tickerCurrencies: "/tickers-currencies"
            }
        }

        var version: APIVersion {
            switch self {
            case .tickerCurrencies: .v1
            }
        }

        var parameters: (any Encodable)? {
            switch self {
            case .tickerCurrencies: nil
            }
        }

        var body: (any Encodable)? {
            switch self {
            case .tickerCurrencies: nil
            }
        }

    }

}
