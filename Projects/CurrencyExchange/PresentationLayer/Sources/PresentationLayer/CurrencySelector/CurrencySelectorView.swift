import SwiftUI

public struct CurrencySelectorView: View {

    @Binding var selectedTicker: String
    @State private var viewModel = CurrencySelectorViewModel()

    public var body: some View {
        VStack(spacing: .doubleGutter) {
            sheetCapsule

            header
                .padding(.top, .defaultGutter)

            LoadableShimmerView(viewModel.viewState) { model in
                currencyList(model)
            } emptyView: {
                EmptyView()
            } errorView: {
                EmptyView()
            }
        }
        .padding(.top, .defaultGutter)
        .padding(.horizontal, .doubleGutter)
        .presentationDetents([.medium])
        .maxSize()
        .background(Color(.backgroundPrimary))
        .task {
            await viewModel.fetchTickers()
        }
    }

}

private extension CurrencySelectorView {

    var sheetCapsule: some View {
        Capsule()
            .fill(Color(.contentSecondary))
            .frame(width: 36, height: 5)
    }

    var header: some View {
        HStack(spacing: .defaultGutter) {
            Text("Choose currency", bundle: #bundle)
                .font(.header4)
                .foregroundStyle(Color(.contentPrimary))
                .maxWidth(alignment: .leading)

            DismissButton()
        }
    }

    func currencyList(_ currencies: [CurrencySelectionModel]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(currencies, id: \.ticker) { currency in
                    Button {
                        selectedTicker = currency.ticker
                    } label: {
                        CurrencySelectionCell(model: currency, isSelected: currency.ticker == selectedTicker)
                    }
                }
            }
            .clipShape(.rect(cornerRadius: .doubleGutter))
        }
    }

}
