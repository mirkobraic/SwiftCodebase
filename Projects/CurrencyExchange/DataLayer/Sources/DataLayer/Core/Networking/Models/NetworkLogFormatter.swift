import Foundation

public enum NetworkLogFormatter {

    case curl(URLRequest, includeData: Bool = true)
    case json(Data)

    var message: String {
        switch self {
        case .curl(let request, let includeData):
            curlString(from: request, includeData: includeData)
        case .json(let data):
            jsonString(from: data)
        }
    }

    private func curlString(from request: URLRequest, includeData: Bool) -> String {
        let cURL = "curl -f"
        let method = "-X \(request.httpMethod ?? "GET")"
        let url = request.url.flatMap { "--url '\($0.absoluteString)'" }
        let header = request.allHTTPHeaderFields?
            .map { "-H '\($0): \($1)'" }
            .joined(separator: " ")
        var data: String?

        if
            includeData,
            let httpBody = request.httpBody,
            !httpBody.isEmpty
        {
            if let bodyString = String(data: httpBody, encoding: .utf8) {
                // json and plain text
                let escaped = bodyString
                    .replacingOccurrences(of: "'", with: "'\\''")
                data = "--data '\(escaped)'"
            } else {
                // Binary data
                let hexString = httpBody
                    .map { String(format: "%02X", $0) }
                    .joined()
                data = #"--data "$(echo '\#(hexString)' | xxd -p -r)""#
            }
        }

        return [cURL, method, url, header, data]
            .compactMap { $0 }
            .joined(separator: " ")

    }

    private func jsonString(from data: Data) -> String {
        if
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted, .withoutEscapingSlashes]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        {
            return prettyString
        } else {
            return String(data: data, encoding: .utf8) ?? "Invaild JSON data - unable to parse the provided data."
        }
    }

}
