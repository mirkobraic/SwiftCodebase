public protocol CurrencySelectorUseCaseProtocol: Actor {

    func getAvailableCurrencies() async throws -> [String]

}
