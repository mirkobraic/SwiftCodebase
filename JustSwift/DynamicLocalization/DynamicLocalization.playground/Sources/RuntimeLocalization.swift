import Foundation

typealias LocalizationItems = [String: String]

public struct RuntimeLocalization: Decodable {
    let values: [String: [String: LocalizationItems]]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        values = try container.decode([String: [String: LocalizationItems]].self)
    }
}

// use if localization response has unknown depth
//indirect enum RuntimeLocalization: Decodable {
//    case item(LocalizationItems)
//    case nest([String: RuntimeLocalization])
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let languageItems = try? container.decode(LocalizationItems.self) {
//            self = .item(languageItems)
//        }
//        else {
//            let nested = try container.decode([String: RuntimeLocalization].self)
//            self = .nest(nested)
//        }
//    }
//}
