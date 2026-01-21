import SwiftUI

struct CurrencySelectionCell: View {

    let model: CurrencySelectionModel
    let isSelected: Bool

    var body: some View {
        HStack(spacing: .defaultGutter) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.backgroundPrimary))
                    .frame(width: 40, height: 40)

                Image(model.imageName, bundle: #bundle)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .clipShape(.circle)
            }

            Text(model.ticker)
                .font(.body)
                .foregroundStyle(Color(.contentPrimary))
                .maxWidth(alignment: .leading)

            Image(isSelected ? .radioSelected : .radioDeselected)
                .resizable()
                .frame(width: 24, height: 24)
                .clipShape(.circle)
        }
        .padding(.vertical, .defaultGutter)
        .padding(.horizontal, .doubleGutter)
        .background(Color(.backgroundSecondary))
    }

}
