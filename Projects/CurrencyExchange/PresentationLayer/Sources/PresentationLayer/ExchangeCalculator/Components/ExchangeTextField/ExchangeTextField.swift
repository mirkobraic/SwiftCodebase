import SwiftUI

struct ExchangeTextField: View {

    @Binding var model: ExchangeTextFieldModel
    let onTickerTap: (() -> Void)?

    var body: some View {
        HStack(spacing: .defaultGutter) {
            tickerButton

            inputField
        }
        .padding(.horizontal, .doubleGutter)
        .padding(.vertical, .gutter(withMultiplier: 3))
        .background(
            RoundedRectangle(cornerRadius: .doubleGutter)
                .fill(Color(.backgroundSecondary))
        )
    }

}

private extension ExchangeTextField {

    var tickerButton: some View {
        Button {
            onTickerTap?()
        } label: {
            HStack(spacing: .defaultGutter) {
                if let image = model.imageName {
                    Image(image, bundle: #bundle)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .clipShape(.circle)
                }

                Text(model.ticker)
                    .font(.body)
                    .foregroundStyle(Color(.contentPrimary))

                if model.supportsSelection {
                    Image(.chevronDown)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                }
            }
        }
        .foregroundStyle(.primary)
        .disabled(!model.supportsSelection)
    }

    var inputField: some View {
        TextField("", value: $model.amount, format: .customCurrency(symbol: "$", maxValue: Constants.currencyMax))
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .font(.bodyBold)
            .foregroundStyle(Color(.contentPrimary))
            .maxWidth(alignment: .trailing)
    }

}
