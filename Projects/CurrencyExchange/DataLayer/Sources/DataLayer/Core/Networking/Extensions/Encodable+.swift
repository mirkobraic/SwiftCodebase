import Foundation

extension Encodable {

    func queryItems(with encoder: JSONEncoder) -> [URLQueryItem]? {
        guard
            let data = try? encoder.encode(self),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else { return nil }

        return jsonObject.compactMap { key, value in
            if let arrayValue = value as? [Any] {
                let joinedValue = arrayValue.map { "\($0)" }.joined(separator: ",")

                return URLQueryItem(name: key, value: joinedValue)
            }

            return URLQueryItem(name: key, value: "\(value)")
        }
    }

    func httpBody(with encoder: JSONEncoder) -> Data? {
        try? encoder.encode(self)
    }

}
