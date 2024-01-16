import Foundation

/// Assings true if value is 1, 1.0, "1", "yes", "true", otherwise false
@propertyWrapper
struct DecodeBool: Decodable {
    var wrappedValue: Bool

    init() {
        wrappedValue = false
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // handle String value
        if let stringValue = try? container.decode(String.self) {
            switch stringValue.lowercased() {
            case "false", "no", "0": wrappedValue = false
            case "true", "yes", "1": wrappedValue = true
            default: wrappedValue = false
            }
        }
        // handle Int value
        else if let intValue = try? container.decode(Int.self) {
            switch intValue {
            case 0: wrappedValue = false
            case 1: wrappedValue = true
            default: wrappedValue = false
            }
        }
        // handle Int value
        else if let doubleValue = try? container.decode(Double.self) {
            switch doubleValue {
            case 0: wrappedValue = false
            case 1: wrappedValue = true
            default: wrappedValue = false
            }
        } else {
            wrappedValue = (try? container.decode(Bool.self)) ?? false
        }
    }
}

extension KeyedDecodingContainer {
    func decode(_: DecodeBool.Type, forKey key: Key) throws -> DecodeBool {
        if let value = try decodeIfPresent(DecodeBool.self, forKey: key) {
            return value
        } else {
            return DecodeBool()
        }
    }
}

extension DecodeBool: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
