import SwiftUI

/// A custom layout that arranges subviews horizontally based on their assigned proportions,
/// with support for vertical alignment.
///
/// Each subview can be assigned a proportion value, dictating how much space it should
/// occupy relative to other subviews. If no proportion is provided, a default value of `1` is used.
///
/// - Parameters:
///   - alignment: Vertical alignment of subviews, default is `.center`.
///   - spacing: The space between subviews, with a default value of `0`.
///
/// # Example
/// ```swift
/// ProportionalHStack(alignment: .top, spacing: 10) {
///     Text("A")
///         .proportion(1)
///     Text("B")
///         .proportion(3)
///     Text("C")
///         .proportion(2)
/// }
/// ```
/// This results in the following layout:
///
/// | - A - | - - - B - - - | - - C - - |
public struct ProportionalHStack: Layout {

    struct ProportionKey: LayoutValueKey {

        static let defaultValue: Double = 1

    }

    let alignment: VerticalAlignment
    let spacing: CGFloat

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat = 0) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }

        let widthProposal = proposal.width ?? 0
        let unitWidth = unitWidth(for: subviews, in: widthProposal)

        let maxHeight = subviews
            .compactMap { view in
                let proportion = view[ProportionKey.self]
                let viewWidth = unitWidth * proportion
                let newProposal = ProposedViewSize(width: viewWidth, height: proposal.height)

                let size = view.sizeThatFits(newProposal)
                return size.height.isFinite ? size.height : nil
            }
            .max() ?? 0

        return CGSize(width: widthProposal, height: maxHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }

        let unitWidth = unitWidth(for: subviews, in: bounds.width)
        let maxHeight = subviews
            .compactMap { view in
                let proportion = view[ProportionKey.self]
                let viewWidth = unitWidth * proportion
                let newProposal = ProposedViewSize(width: viewWidth, height: .infinity)

                let size = view.sizeThatFits(newProposal)
                return size.height.isFinite ? size.height : nil
            }
            .max() ?? 0

        var origin = bounds.origin

        for view in subviews {
            let proportion = view[ProportionKey.self]
            let viewWidth = unitWidth * proportion
            let viewSize = view.sizeThatFits(ProposedViewSize(width: viewWidth, height: maxHeight))

            let yOffset: CGFloat
            switch alignment {
            case .top:
                yOffset = bounds.minY
            case .center:
                yOffset = bounds.minY + (maxHeight - viewSize.height) / 2
            case .bottom:
                yOffset = bounds.minY + (maxHeight - viewSize.height)
            default:
                yOffset = bounds.minY + (maxHeight - viewSize.height) / 2
            }

            view.place(
                at: CGPoint(x: origin.x, y: yOffset),
                proposal: ProposedViewSize(width: viewWidth, height: maxHeight))
            origin.x += viewWidth + spacing
        }
    }

    private func unitWidth(for subviews: Subviews, in width: CGFloat) -> CGFloat {
        let totalProportions = subviews.map { $0[ProportionKey.self] }.reduce(0, +)
        let totalSpacing = CGFloat(subviews.count - 1) * spacing

        let availableWidth = width - totalSpacing
        let unitWidth = availableWidth / totalProportions

        return unitWidth
    }

}

extension View {

    /// Sets the proportion for a view inside a `ProportionalHStack`.
    public func proportion(_ proportion: Double) -> some View {
        layoutValue(key: ProportionalHStack.ProportionKey.self, value: proportion)
    }

}
