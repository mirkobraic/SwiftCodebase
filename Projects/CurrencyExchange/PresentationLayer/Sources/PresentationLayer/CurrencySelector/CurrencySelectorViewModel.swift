import SwiftUI
import FactoryKit

@Observable @MainActor
public class CurrencySelectorViewModel {

    @ObservationIgnored @Injected(\.currencySelectorUseCase) private var useCase

    var viewState: Loadable<[CurrencySelectionModel]> = .initial(placeholder: .placeholder)

    func fetchTickers() async {
        do {
            let currencies = try await useCase.getAvailableCurrencies()
                .map { CurrencySelectionModel(ticker: $0, imageName: $0) }

            withAnimation {
                viewState = currencies.isEmpty ? .empty : .loaded(currencies)
            }
        } catch {
            withAnimation {
                viewState = .error
            }
        }
    }

}
