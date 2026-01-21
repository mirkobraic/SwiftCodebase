import Foundation

public actor APIClient: APIClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = .appDecoder, encoder: JSONEncoder = .init()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    public func request<E: APIEndpoint>(_ endpoint: E) async throws {
        let request = try makeURLRequest(from: endpoint)
        try await execute(request: request)
    }
    
    public func request<E: APIEndpoint, T: Decodable>(_ endpoint: E) async throws -> T {
        let request = try makeURLRequest(from: endpoint)
        let data = try await execute(request: request)

        return try decoder.decode(T.self, from: data)
    }

    private func makeURLRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = APIScheme.https.rawValue
        components.host = Environment.current.baseApiPath
        components.path = endpoint.versionedPath
        components.queryItems = endpoint.parameters?.queryItems(with: encoder)

        guard let url = components.url else { throw APIClientError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body?.httpBody(with: encoder)

        return request
    }

    @discardableResult
    private func execute(request: URLRequest) async throws -> Data {
        print(NetworkLogFormatter.curl(request).message)

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }

        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200...299:
            print(NetworkLogFormatter.json(data).message)
            return data
        case 400...499:
            throw APIClientError.clientError(statusCode)
        case 500...599:
            throw APIClientError.serverError(statusCode)
        default:
            throw APIClientError.unexpectedStatusCode(statusCode)
        }
    }

}
