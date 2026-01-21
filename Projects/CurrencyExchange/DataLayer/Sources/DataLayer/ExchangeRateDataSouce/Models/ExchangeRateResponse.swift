import Foundation
import DomainLayer

struct ExchangeRateResponse: Decodable {

    let ask: String
    let bid: String
    let book: String
    let date: Date

}

extension ExchangeRateResponse {

    func toDomainModel() -> ExchangeRateModel? {
        let bookComponents = book.split(separator: "_")
        guard
            let ask = Decimal(string: ask),
            let bid = Decimal(string: bid),
            let baseTicker = bookComponents.first.map(String.init),
            let quoteTicker = bookComponents.last.map(String.init)
        else { return nil }


        return ExchangeRateModel(ask: ask, bid: bid, base: .init(baseTicker), quote: .init(quoteTicker), date: date)
    }

}
