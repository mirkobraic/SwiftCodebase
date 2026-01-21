import SwiftUI

public struct CollapsingHeaderScrollViewConfiguration {

    public enum CollapseStyle {

        /// Keeps the bottom visible while scrolling
        case standard
        /// Reduces the size of the header while scrolling
        case compress(alignment: VerticalHeaderAlignment)
        /// Keeps the top visible while scrolling
        case fixed

    }

    public enum VerticalHeaderAlignment {

        /// Keeps the top stationary while the bottom is clipped as the header size reduces.
        case top
        /// Keeps the center stationary while both the top and bottom are clipped equally as the header size reduces.
        case center
        /// Keeps the bottom stationary while the top is clipped as the header size reduces.
        case bottom

        var headerAlignment: Alignment {
            switch self {
            case .top:
                Alignment(horizontal: .center, vertical: .top)
            case .center:
                Alignment(horizontal: .center, vertical: .center)
            case .bottom:
                Alignment(horizontal: .center, vertical: .bottom)
            }
        }

    }

    let collapseStyle: CollapseStyle
    let minHeaderHeight: CGFloat
    let maxHeaderHeight: CGFloat
    let disableBounce: Bool
    let initialDataLoaded: Bool
    /// Defines the increment step as a percentage, ranging from 0 to 1, used to update the `progressBinding`.
    /// By setting this value, you can control how frequently the binding is updated, which
    /// can be particularly useful for improving performance in scenarios where continuous updates
    /// may be computationally expensive or unnecessary.
    let progressStep: CGFloat
    let progressBinding: Binding<CGFloat>?
    let refreshingBinding: Binding<Bool>?
    let enableRefreshProgressView: Bool
    let refreshThreshold: CGFloat = -100

    public init(
        collapseStyle: CollapseStyle,
        maxHeaderHeight: CGFloat,
        minHeaderHeight: CGFloat = 0,
        disableBounce: Bool = false,
        initialDataLoaded: Bool = true,
        progressStep: CGFloat = 0.01,
        progressBinding: Binding<CGFloat>? = nil,
        refreshingBinding: Binding<Bool>? = nil,
        enableRefreshProgressView: Bool? = nil
    ) {
        assert(minHeaderHeight < maxHeaderHeight)
        assert(progressStep >= 0 && progressStep <= 1)

        self.collapseStyle = collapseStyle
        self.maxHeaderHeight = maxHeaderHeight
        self.minHeaderHeight = minHeaderHeight
        self.disableBounce = disableBounce
        self.initialDataLoaded = initialDataLoaded
        self.progressStep = progressStep
        self.progressBinding = progressBinding
        self.refreshingBinding = refreshingBinding
        self.enableRefreshProgressView = enableRefreshProgressView ?? refreshingBinding.isNotNil
    }

}

struct ScrollOffsetPreferenceKey: PreferenceKey {

    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }

}
