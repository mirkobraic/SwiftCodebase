import SwiftUI

/// A custom layout that arranges subviews horizontally based on their assigned percentages.
///
/// Subviews with a percentage value dictate their specific width (relative to the total width),
/// while subviews with a `nil` percentage share the remaining space equally.
///
/// - Parameters:
///   - alignment: Vertical alignment of subviews, default is `.center`.
///   - spacing: The space between subviews, with a default value of `0`.
///
/// # Example
/// ```swift
/// RelativeHStack(alignment: .top, spacing: 10) {
///     Text("A")
///         .widthPercentage(0.2)
///     Text("B")
///         .widthPercentage(nil) // Will share remaining space equally with C.
///     Text("C")
///         .widthPercentage(nil)
/// }
/// ```
/// This results in the following layout:
///
/// | --- A --- | -------- B -------- | -------- C -------- |
public struct RelativeHStack: Layout {

    struct PercentKey: LayoutValueKey {

        static let defaultValue: Double? = nil

    }

    let alignment: VerticalAlignment
    let spacing: Double

    public init(alignment: VerticalAlignment = .center, spacing: Double = 0) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }

        let widthProposal = proposal.width ?? 0
        let allocatedWidths = calculateAllocatedWidths(subviews: subviews, totalWidth: widthProposal)

        let maxHeight = subviews.enumerated()
            .map { index, view in
                guard let viewWidth = allocatedWidths[safe: index] else { return 0 }

                let newProposal = ProposedViewSize(width: viewWidth, height: proposal.height)
                return view.sizeThatFits(newProposal).height
            }
            .max() ?? 0

        return CGSize(width: widthProposal, height: maxHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }

        let allocatedWidths = calculateAllocatedWidths(subviews: subviews, totalWidth: bounds.width)
        var origin = bounds.origin

        for (index, view) in subviews.enumerated() {
            guard let viewWidth = allocatedWidths[safe: index] else { continue }

            let viewSize = view.sizeThatFits(ProposedViewSize(width: viewWidth, height: proposal.height))

            let yOffset: CGFloat
            switch alignment {
            case .top:
                yOffset = bounds.minY
            case .center:
                yOffset = bounds.midY - viewSize.height / 2
            case .bottom:
                yOffset = bounds.maxY - viewSize.height
            default:
                yOffset = bounds.midY - viewSize.height / 2
            }

            view.place(
                at: CGPoint(x: origin.x, y: yOffset),
                proposal: ProposedViewSize(width: viewWidth, height: viewSize.height))
            origin.x += viewWidth + spacing
        }
    }

    private func calculateAllocatedWidths(subviews: Subviews, totalWidth: Double) -> [Double] {
        let totalSpacing = Double(subviews.count - 1) * spacing
        let availableWidth = totalWidth - totalSpacing

        let allocatedWidth = subviews
            .compactMap { $0[PercentKey.self] }
            .reduce(0) { acc, percentage in
                acc + percentage * availableWidth
            }

        let remainingWidth = availableWidth - allocatedWidth
        let remainingViewsCount = subviews.filter { $0[PercentKey.self] == nil }.count

        return subviews.map {
            if let percentage = $0[PercentKey.self] {
                percentage * availableWidth
            } else if remainingViewsCount > 0 {
                remainingWidth / Double(remainingViewsCount)
            } else {
                0
            }
        }
    }

}

extension View {

    /// Sets the percentage for a view inside a `RelativeHStack`.
    /// If `nil` is provided, the view will share the remaining space equally
    /// with other `nil` views.
    public func widthPercentage(_ percentage: Double?) -> some View {
        layoutValue(key: RelativeHStack.PercentKey.self, value: percentage)
    }

}
