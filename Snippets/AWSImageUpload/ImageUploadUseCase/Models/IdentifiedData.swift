import Foundation

public struct IdentifiedData: Identifiable, Sendable {

    public let id: String
    public let data: Data

    public init(id: String, data: Data) {
        self.id = id
        self.data = data
    }

}
