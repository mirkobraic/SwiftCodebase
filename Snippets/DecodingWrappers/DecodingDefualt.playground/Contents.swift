import Foundation

protocol DefaultValueProvider {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

enum EmptyString: DefaultValueProvider {
    static var defaultValue: String { "" }
}

enum NilString: DefaultValueProvider {
    static var defaultValue: String? { nil }
}

/// Assings default value to a property if decoding fails for any reason
@propertyWrapper
struct DecodingDefault<Provider: DefaultValueProvider>: Decodable {
    var wrappedValue: Provider.Value

    init() {
        wrappedValue = Provider.defaultValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            wrappedValue = Provider.defaultValue
        } else {
            wrappedValue = (try? container.decode(Provider.Value.self)) ?? Provider.defaultValue
        }
    }
}

extension DecodingDefault: Equatable where Provider.Value: Equatable {}
extension DecodingDefault: Hashable where Provider.Value: Hashable {}

extension KeyedDecodingContainer {
    func decode<P>(_: DecodingDefault<P>.Type, forKey key: Key) throws -> DecodingDefault<P> {
        if let value = try decodeIfPresent(DecodingDefault<P>.self, forKey: key) {
            return value
        } else {
            return DecodingDefault()
        }
    }
}

extension DecodingDefault: Encodable where Provider.Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
