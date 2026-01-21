import Foundation

public struct ImageUploadResult: Identifiable, Sendable {

    public let id: String
    let value: Result<URL, Error>

    public init(id: String, value: Result<URL, Error>) {
        self.id = id
        self.value = value
    }

}
