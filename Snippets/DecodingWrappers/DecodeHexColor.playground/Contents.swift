import UIKit

/// Decodes hex string into UIColor
@propertyWrapper
struct DecodeHexColor: Decodable {
    var wrappedValue: UIColor?

    init() {
        wrappedValue = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            wrappedValue = nil
        } else {
            if let str = try? container.decode(String.self) {
                wrappedValue = UIColor(hex: str)
            } else {
                wrappedValue = nil
            }
        }
    }
}

extension KeyedDecodingContainer {
    func decode(_: DecodeHexColor.Type, forKey key: Key) throws -> DecodeHexColor {
        if let value = try decodeIfPresent(DecodeHexColor.self, forKey: key) {
            return value
        } else {
            return DecodeHexColor()
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var hexNumber: UInt64 = 0
        if Scanner(string: hexString).scanHexInt64(&hexNumber) {
            if hexString.count == 6 {
                hexNumber <<= 8
                hexNumber |= 0x000000ff
            }
            let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            let a = CGFloat(hexNumber & 0x000000ff) / 255

            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }
        return nil
    }
}
