public protocol APIClientProtocol: Actor {

    func request<E: APIEndpoint>(_ endpoint: E) async throws

    func request<E: APIEndpoint, T: Decodable>(_ endpoint: E)  async throws -> T

}
