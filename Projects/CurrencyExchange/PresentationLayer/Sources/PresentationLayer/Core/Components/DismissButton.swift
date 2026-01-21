import SwiftUI

struct DismissButton: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(.xButton)
                .resizable()
                .frame(width: 32, height: 32)
        }
    }

}
