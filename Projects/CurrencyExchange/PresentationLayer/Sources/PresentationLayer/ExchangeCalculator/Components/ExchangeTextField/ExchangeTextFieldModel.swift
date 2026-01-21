import Foundation

struct ExchangeTextFieldModel {

    var ticker: String
    var imageName: String?
    var amount: Decimal
    var supportsSelection: Bool

}

extension ExchangeTextFieldModel {

    var isUSDc: Bool {
        ticker == Constants.usdcTicker
    }

    static let USDc = ExchangeTextFieldModel(
        ticker: Constants.usdcTicker,
        imageName: Constants.usdcTicker,
        amount: 0,
        supportsSelection: false
    )

}
