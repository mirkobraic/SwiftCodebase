public struct Ticker: Sendable, Equatable, ExpressibleByStringLiteral, CustomStringConvertible {

    let value: String

    public init(stringLiteral value: StringLiteralType) {
        self.value = value.lowercased()
    }

    public init(_ value: String) {
        self.value = value.lowercased()
    }


    public var description: String { value }

}
