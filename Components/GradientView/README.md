# GradientView

A simple, customizable gradient view component for iOS applications built with UIKit.

Instead of manually configuring `CAGradientLayer` properties, `GradientView` provides a clean interface with reactive properties that update the gradient automatically.

## Quick Start

```swift
let gradientView = GradientView()
gradientView.colors = [.blue, .purple]
gradientView.startPoint = CGPoint(x: 0, y: 0)
gradientView.endPoint = CGPoint(x: 1, y: 1)
view.addSubview(gradientView)
```

## Properties

- `colors`: Array of `UIColor` objects
- `locations`: Gradient stop positions (0.0 to 1.0)
- `startPoint`/`endPoint`: Control gradient direction
- `type`: Gradient type (axial, radial, conic)
