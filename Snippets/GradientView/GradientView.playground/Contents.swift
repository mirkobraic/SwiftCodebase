import UIKit

class GradientView: UIView {
    override static var layerClass: AnyClass { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    init() {
        super.init(frame: .zero)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.type = type
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var colors: [UIColor] = [.black, .clear] {
        didSet {
            gradientLayer.colors = colors.map { $0.cgColor }
        }
    }

    var locations: [NSNumber] = [0.0, 1.0] {
        didSet {
            gradientLayer.locations = locations
        }
    }

    var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }

    var endPoint: CGPoint = CGPoint(x: 1, y: 0) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }

    var type: CAGradientLayerType = .axial {
        didSet {
            gradientLayer.type = type
        }
    }
}
