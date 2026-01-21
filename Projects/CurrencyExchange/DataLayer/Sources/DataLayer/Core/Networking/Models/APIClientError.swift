enum APIClientError: Error {

    case invalidURL
    case invalidResponse
    case clientError(Int)
    case serverError(Int)
    case unexpectedStatusCode(Int)

}
