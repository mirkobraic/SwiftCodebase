import Foundation

public extension JSONDecoder {

    static let appDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(decodeDate)
        return decoder
    }()

    @Sendable private static func decodeDate(_ decoder: any Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        for formatter in dateFormatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Cannot decode date string \(dateString). No available formatter could parse it.")
    }

    private static let dateFormatters: [DateFormatterProtocol] = [
        DateFormatter.iso8601Full,
        DateFormatter.iso8601WithoutFractionalSeconds,
        DateFormatter.iso8601NoTimezone,
        DateFormatter.isoWith2Fractional
    ]

}

public extension DateFormatter {

    static let iso8601Full: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        // Example: 2024-12-25T10:30:00.123Z
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let iso8601WithoutFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        // Example: 2024-12-25T10:30:00Z
        formatter.formatOptions = .withInternetDateTime
        return formatter
    }()

    static let iso8601NoTimezone: DateFormatter = {
        let formatter = DateFormatter()
        // Example: 2024-12-25T10:30:00
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .gmt
        return formatter
    }()

    static let isoWith2Fractional: DateFormatter = {
        let formatter = DateFormatter()
        // Example: 2024-10-04T00:14:00.78
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .gmt
        return formatter
    }()

}

extension DateFormatter: DateFormatterProtocol {}

extension ISO8601DateFormatter: DateFormatterProtocol {}
