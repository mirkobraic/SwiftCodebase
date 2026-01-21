import SwiftUI

/// A custom `TabView` that preserves the height of the content across all tabs.
///
/// This view ensures that the height of the `TabView` matches the height of the tallest child view,
/// regardless of which tab is selected. This is especially useful when embeding `TabView` in a `ScrollView`,
/// where `TabView` would normally have a height of 0 by default.
struct HeightPreservingTabView<SelectionValue: Hashable, Content: View>: View {

    var selection: Binding<SelectionValue>
    var content: Content

    /// `minHeight` needs to be non-zero or we won't be able measure the child view content height. Purely SwiftUI issue :/
    @State private var minHeight: CGFloat = 1

    init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.selection = selection
        self.content = content()
        self.minHeight = minHeight
    }

    var body: some View {
        ZStack {
            // A hidden view used to measure the maximum height of the content.
            // Reading the height from a TabView only gives the height of the currently visible view,
            // which isn't enough to get the height of the tallest view in the set.
            measuredContent

            TabView(selection: selection) {
                content
            }
            .frame(minHeight: minHeight)
        }
        .onPreferenceChange(MaxValuePreferenceKey.self) {
            self.minHeight = $0
        }
    }

    private var measuredContent: some View {
        content
            .background {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: MaxValuePreferenceKey.self,
                        value: geometry.frame(in: .local).height)
                }
            }
            .hidden()
    }

}

struct MaxValuePreferenceKey: PreferenceKey {

    static var defaultValue: CGFloat = 1

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }

}
