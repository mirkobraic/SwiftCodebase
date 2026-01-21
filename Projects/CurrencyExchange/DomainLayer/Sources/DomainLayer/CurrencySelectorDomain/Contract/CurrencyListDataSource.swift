public protocol CurrencyListDataSource: Actor {

    func getAvailableCurrencies() async throws -> [String]

}
