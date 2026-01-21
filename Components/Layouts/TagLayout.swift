import SwiftUI

public struct TagLayout: Layout {

    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    public init(horizontalSpacing: CGFloat = .doubleGutter, verticalSpacing: CGFloat = .defaultGutter) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }

        let maxWidth = proposal.width ?? 0
        let rows = generateRows(maxWidth, proposal, subviews)

        var height: CGFloat = 0

        // find max height in each row and add it to the view's total height
        for (index, row) in rows.enumerated() {
            // vertical spacing is not needed for the last row
            let verticalSpacing = index + 1 == rows.endIndex ? 0 : self.verticalSpacing

            height += row.maxHeight(proposal) + verticalSpacing
        }

        return CGSize(width: maxWidth, height: height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }

        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)

        var origin = bounds.origin

        for row in rows {
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                origin.x += viewSize.width + horizontalSpacing
            }

            origin.x = bounds.origin.x
            origin.y += row.maxHeight(proposal) + verticalSpacing
        }
    }

    func generateRows(
        _ maxWidth: CGFloat,
        _ proposedViewSize: ProposedViewSize,
        _ subviews: Subviews
    ) -> [[LayoutSubviews.Element]] {
        var rowBuffer: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        var origin = CGRect.zero.origin

        for view in subviews {
            let viewSize = view.sizeThatFits(proposedViewSize)

            if (origin.x + viewSize.width + horizontalSpacing) > maxWidth {
                // create a new row
                rows.append(rowBuffer)
                rowBuffer.removeAll()

                origin.x = 0
            }
            rowBuffer.append(view)
            origin.x += viewSize.width + horizontalSpacing
        }

        // check for items in a buffer
        if !rowBuffer.isEmpty {
            rows.append(rowBuffer)
            rowBuffer.removeAll()
        }

        return rows
    }

}

extension [LayoutSubviews.Element] {

    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        compactMap { $0.sizeThatFits(proposal).height }.max() ?? 0
    }

}
