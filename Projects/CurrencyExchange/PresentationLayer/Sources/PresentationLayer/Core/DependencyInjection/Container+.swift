import FactoryKit
import DomainLayer

public extension Container {

    var currencySelectorUseCase: Factory<CurrencySelectorUseCaseProtocol> {
        self { fatalError("currencySelectorUseCase not registered") }
            .singleton
    }

    var exchangeCalculatorUseCase: Factory<ExchangeCalculatorUseCaseProtocol> {
        self { fatalError("exchangeCalculatorUseCase not registered") }
            .singleton
    }

}
