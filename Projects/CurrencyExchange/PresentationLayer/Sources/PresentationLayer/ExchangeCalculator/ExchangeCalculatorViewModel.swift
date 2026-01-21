import Foundation
import Observation
import FactoryKit
import DomainLayer

@Observable @MainActor
public class ExchangeCalculatorViewModel {

    @ObservationIgnored @Injected(\.exchangeCalculatorUseCase) private var useCase

    var exchangeEditorViewModel = ExchangeEditorViewModel(
        primaryField: .USDc,
        secondaryField: .init(ticker: "MXN", imageName: "MXN", amount: 0, supportsSelection: true) // TODO: Default ticker value should be loaded from storage (user defaults, for example)
    )

    var currencySelectionActiveInput: ExchangeEditorInputType?
    var subtitleText: Loadable<String> = .initial(placeholder: "Placeholder string")

    private var exchangeRate: ExchangeRateModel?

    private func fetchExchangeRate(for ticker: String) async {
        guard !ticker.isEmpty else {
            subtitleText = .empty
            return
        }

        do {
            let model = try await useCase.getUSDcExchangeRate(for: ticker)
            updateViewModel(with: model)
        } catch {
            subtitleText = .error
        }
    }

    private func updateViewModel(with exchangeRate: ExchangeRateModel) {
        self.exchangeRate = exchangeRate
        exchangeEditorViewModel.update(exchangeRate: exchangeRate)
        updateSubtitleText(for: exchangeRate)
    }

    private func updateSubtitleText(for exchangeRate: ExchangeRateModel) {
        let baseTicker = exchangeRate.base.description.uppercased() // TODO: fix uppercase C issue
        let quoteTicker = exchangeRate.quote.description.uppercased()
        let rate = exchangeRate.getExchangeCoeficient(
            selling: .init(exchangeEditorViewModel.primaryField.ticker),
            buying: .init(exchangeEditorViewModel.secondaryField.ticker)
        )

        let subtitle = String(
            format: "%@ = %@",
            Decimal(1).asCurrency(currencySymbol: baseTicker),
            rate.asCurrency(currencySymbol: quoteTicker)
        )

        subtitleText = .loaded(subtitle)
    }

}

extension ExchangeCalculatorViewModel {

    func viewAppearedTask() async {
        await fetchExchangeRate(for: exchangeEditorViewModel.getTicker(for: .secondary))
    }

    func tickerButtonTap(_ field: ExchangeEditorInputType) {
        currencySelectionActiveInput = field
    }

    func currenciesSwitched() {
        guard let exchangeRate else { return }

        updateSubtitleText(for: exchangeRate)
    }

    func getTicker(for field: ExchangeEditorInputType) -> String {
        exchangeEditorViewModel.getTicker(for: field)
    }

    func currencySelected(for field: ExchangeEditorInputType, newValue: String) {
        exchangeEditorViewModel.update(ticker: newValue, for: field)

        currencySelectionActiveInput = nil
        Task {
            await fetchExchangeRate(for: newValue)
        }
    }

}
