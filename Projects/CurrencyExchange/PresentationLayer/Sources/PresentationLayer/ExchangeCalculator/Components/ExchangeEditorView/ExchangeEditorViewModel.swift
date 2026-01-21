import Foundation
import Observation
import DomainLayer

@Observable
class ExchangeEditorViewModel {

    var primaryField: ExchangeTextFieldModel
    var secondaryField: ExchangeTextFieldModel

    private var exchangeRate: ExchangeRateModel?

    private var primaryTicker: Ticker { .init(primaryField.ticker) }
    private var secondaryTicker: Ticker { .init(secondaryField.ticker) }

    init(
        primaryField: ExchangeTextFieldModel,
        secondaryField: ExchangeTextFieldModel,
        exchangeRate: ExchangeRateModel? = nil
    ) {
        self.primaryField = primaryField
        self.secondaryField = secondaryField
        self.exchangeRate = exchangeRate
    }

    func update(exchangeRate: ExchangeRateModel) {
        self.exchangeRate = exchangeRate

        // Find which input contains quote ticker and update it.
        if primaryTicker == exchangeRate.quote {
            let result = calculateExchange(for: secondaryField, with: exchangeRate)
            primaryField.amount = result.amount
        } else if secondaryTicker == exchangeRate.quote {
            let result = calculateExchange(for: primaryField, with: exchangeRate)
            secondaryField.amount = result.amount
        }
    }

    func getTicker(for field: ExchangeEditorInputType) -> String {
        switch field {
        case .primary:
            primaryField.ticker
        case .secondary:
            secondaryField.ticker
        }
    }
    
    func update(ticker: String, for field: ExchangeEditorInputType) {
        switch field {
        case .primary:
            primaryField.ticker = ticker
            primaryField.imageName = ticker
        case .secondary:
            secondaryField.ticker = ticker
            secondaryField.imageName = ticker
        }
    }

    func userInputChanged(in field: ExchangeEditorInputType) {
        guard let exchangeRate else { return }

        switch field {
        case .primary:
            let result = calculateExchange(for: primaryField, with: exchangeRate)
            secondaryField.amount = result.amount
        case .secondary:
            let result = calculateExchange(for: secondaryField, with: exchangeRate)
            primaryField.amount = result.amount
        }
    }

    func switchCurrenciesButtonTap() {
        swap(&primaryField, &secondaryField)

        // TODO: Fix bug when swapping fields which have max values.
        if let exchangeRate {
            update(exchangeRate: exchangeRate)
        }
    }

    private func calculateExchange(
        for inputField: ExchangeTextFieldModel,
        with exchangeRate: ExchangeRateModel
    ) -> ExchangePayload {
        let inputPayload = ExchangePayload(ticker: inputField.ticker, amount: inputField.amount)
        let outputPayload = exchangeRate.exchange(inputPayload, selling: primaryTicker, buying: secondaryTicker)

        return outputPayload
    }

}
