import SwiftUI

struct ExchangeEditorView: View {

    @FocusState private var focusedField: ExchangeEditorInputType?
    @Bindable var viewModel: ExchangeEditorViewModel
    var currencySelectedCallback: ((ExchangeEditorInputType) -> Void)?
    var currenciesSwitchedCallback: (() -> Void)?

    var body: some View {
        VStack(spacing: .doubleGutter) {
            buyingField

            sellingField
        }
        .overlay {
            switchCurrenciesButton
        }
    }
}

private extension ExchangeEditorView {

    var buyingField: some View {
        ExchangeTextField(model: $viewModel.primaryField) {
            currencySelectedCallback?(.primary)
        }
        .focused($focusedField, equals: .primary)
        .onChange(of: viewModel.primaryField.amount) { oldValue, newValue in
            guard
                oldValue.roundedAsCurrency != newValue.roundedAsCurrency,
                focusedField == .primary
            else { return }

            viewModel.userInputChanged(in: .primary)
        }
    }

    var sellingField: some View {
        ExchangeTextField(model: $viewModel.secondaryField) {
            currencySelectedCallback?(.secondary)
        }
        .focused($focusedField, equals: .secondary)
        .onChange(of: viewModel.secondaryField.amount) { oldValue, newValue in
            guard
                oldValue.roundedAsCurrency != newValue.roundedAsCurrency,
                focusedField == .secondary
            else { return }

            viewModel.userInputChanged(in: .secondary)
        }
    }

    var switchCurrenciesButton: some View {
        Button {
            viewModel.switchCurrenciesButtonTap()
            switchFocusedField()
            currenciesSwitchedCallback?()
        } label: {
            Image(.arrowDown)
                .resizable()
                .frame(width: 32, height: 32)
        }
        .background {
            Circle()
                .fill(Color(.backgroundPrimary))
                .frame(width: 32, height: 32)
        }
    }

    func switchFocusedField() {
        switch focusedField {
        case .primary:
            focusedField = .secondary
        case .secondary:
            focusedField = .primary
        case .none:
            break
        }
    }

}

extension ExchangeEditorView {

    func onCurrencyTap(_ callback: @escaping (ExchangeEditorInputType) -> Void) -> ExchangeEditorView {
        var view = self
        view.currencySelectedCallback = callback

        return view
    }

    func onSwitchCurrencies(_ callback: @escaping () -> Void) -> ExchangeEditorView {
        var view = self
        view.currenciesSwitchedCallback = callback

        return view
    }

}
