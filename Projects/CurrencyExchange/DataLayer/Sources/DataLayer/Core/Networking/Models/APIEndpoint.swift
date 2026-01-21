import Foundation

public protocol APIEndpoint: Sendable {

    var method: HTTPMethod { get }
    var path: String { get }
    var version: APIVersion { get }
    var parameters: (any Encodable)? { get }
    var body: (any Encodable)? { get }

}

extension APIEndpoint {

    var versionedPath: String {
        version.path + path
    }

}
