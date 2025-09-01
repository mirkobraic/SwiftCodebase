import SwiftUI

struct ContentView: View {

    @State private var popupData: PopupData?

    var body: some View {
        VStack {
            Spacer()

            Button("Show popup") {
                popupData = .testData
            }
        }
        .padding(.bottom, 150)
        .popupSheet(item: $popupData) { data in
            CustomPopupView(data: data)
        }
    }
}

#Preview {
    ContentView()
}
