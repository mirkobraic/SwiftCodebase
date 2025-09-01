import SwiftUI

struct PopupData: Identifiable {

    let id = UUID()
    let title: String
    let description: String

    static var testData: Self {
        .init(title: "Test title", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
    }

}

struct CustomPopupView: View {

    let data: PopupData

    var body: some View {
        VStack(alignment: .leading) {
            Text(data.title)
                .fontWeight(.bold)

            Text(data.description)
        }
        .padding(.top, 20)
        .padding()
    }

}
