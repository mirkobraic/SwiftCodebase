import Foundation

public extension CGFloat {

    static let defaultGutter = 8.0
    static let doubleGutter = CGFloat.gutter(withMultiplier: 2)

    static func gutter(withMultiplier multiplier: CGFloat = 1.0) -> CGFloat {
        defaultGutter * multiplier
    }

}
