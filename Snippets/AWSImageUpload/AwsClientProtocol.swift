import Foundation

public protocol AwsClientProtocol: Sendable {

    func upload(data: Data, to url: URL, contentType: String) async throws

}
