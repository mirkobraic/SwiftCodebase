import SwiftUI

public struct ExchangeCalculatorView: View {

    @State private var viewModel = ExchangeCalculatorViewModel()

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: .gutter(withMultiplier: 3)) {
            Spacer(minLength: 50)

            headerView

            ExchangeEditorView(viewModel: viewModel.exchangeEditorViewModel)
                .onCurrencyTap { viewModel.tickerButtonTap($0) }
                .onSwitchCurrencies { viewModel.currenciesSwitched() }
                .maxHeight(alignment: .top)
        }
        .padding(.horizontal, .doubleGutter)
        .padding(.top, .gutter(withMultiplier: 3))
        .maxSize()
        .background(Color(.backgroundPrimary))
        .onTapHideKeyboard()
        .sheet(item: $viewModel.currencySelectionActiveInput) { activeField in
            CurrencySelectorView(selectedTicker: Binding {
                viewModel.getTicker(for: activeField)
            } set: { newValue in
                viewModel.currencySelected(for: activeField, newValue: newValue)
            })
        }
        .task { await viewModel.viewAppearedTask() }
    }

}

private extension ExchangeCalculatorView {

    var headerView: some View {
        VStack(alignment: .leading, spacing: .defaultGutter) {
            Text("Exchange calculator", bundle: #bundle)
                .font(.header3)
                .foregroundStyle(Color(.contentPrimary))

            subtitleView
        }
    }

    var subtitleView: some View {
        LoadableShimmerView(viewModel.subtitleText) { text in
            Text(text)
                .font(.body)
                .foregroundStyle(Color.accentColor)
        } emptyView: {
            Text(" ")
                .font(.body)
        } errorView: {
            Text("Unable to load exchange rates.", bundle: #bundle)
                .font(.body)
                .foregroundStyle(Color.red)
        }
    }

}

#Preview {

    NavigationStack {
        ExchangeCalculatorView()
    }

}
