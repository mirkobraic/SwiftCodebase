struct CurrencySelectionModel: Hashable {

    let ticker: String
    let imageName: String

}

extension Array where Element == CurrencySelectionModel {

    static var placeholder: [CurrencySelectionModel] {
        [
            CurrencySelectionModel(ticker: "MXN", imageName: "MXN"),
            CurrencySelectionModel(ticker: "ARS", imageName: "ARS"),
            CurrencySelectionModel(ticker: "BRL", imageName: "BRL"),
            CurrencySelectionModel(ticker: "COP", imageName: "COP"),
            CurrencySelectionModel(ticker: "EURc", imageName: "EURc"),
        ]
    }

}
