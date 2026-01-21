import Foundation
import Dependencies
import Get
import Core

public enum AwsNetworkError: Error, Equatable {

    case failure(_ statusCode: Int, response: String?)

}

final public actor AwsClient: AwsClientProtocol {

    private lazy var client = APIClient(baseURL: nil) {
        $0.delegate = self
    }

    public func upload(data: Data, to url: URL, contentType: String) async throws {
        let request = Request<Void>(url: url, method: .put, body: data, headers: ["Content-Type": contentType])

        try await send(request: request)
    }

    private func send(request: Request<Void>) async throws {
        do {
            let response = try await client.send(request)
            logResponse(for: request, responseData: response.data)
        } catch {
            logResponseError(request: request, error: error)

            throw error
        }
    }

    private func logRequest(_ request: URLRequest) {
        AppLogger.networking.log(
            .info,
            "Sending \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "") request")
        AppLogger.networking.log(.debug, .curl(request, includeData: false))
    }

    private func logResponse<T>(for request: Request<T>, responseData: Data) {
        AppLogger.networking.log(.info, "Received \(request.method.rawValue) \(request.path) response")
        AppLogger.networking.log(.debug, .json(responseData))
    }

    private func logResponseError<T>(request: Request<T>, error: Error) {
        AppLogger.networking.log(.error, "Request \(request.method.rawValue) \(request.path) errored with: \(error)")
    }

}

extension AwsClient: APIClientDelegate {

    public func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        logRequest(request)
    }

    nonisolated public func client(
        _ client: APIClient,
        validateResponse response: HTTPURLResponse,
        data: Data,
        task: URLSessionTask
    ) throws {
        guard (200..<300).contains(response.statusCode) else {
            let responseString = String(data: data, encoding: .utf8)
            throw AwsNetworkError.failure(response.statusCode, response: responseString)
        }
    }

}

extension AwsClient: DependencyKey {

    public static var liveValue: any AwsClientProtocol = AwsClient()

}

public extension DependencyValues {

    var awsClient: AwsClientProtocol {
        get { self[AwsClient.self] }
        set { self[AwsClient.self] = newValue }
    }

}
