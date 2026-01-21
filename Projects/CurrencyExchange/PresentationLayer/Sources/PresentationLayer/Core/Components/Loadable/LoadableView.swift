import SwiftUI

struct LoadableShimmerView<T, Content: View, EmptyView: View, ErrorView: View>: View {

    let model: Loadable<T>

    let content: (T) -> Content
    let emptyView: () -> EmptyView
    let errorView: () -> ErrorView

    init(
        _ model: Loadable<T>,
        @ViewBuilder content: @escaping (T) -> Content,
        @ViewBuilder emptyView: @escaping () -> EmptyView,
        @ViewBuilder errorView: @escaping () -> ErrorView
    ) {
        self.model = model
        self.content = content
        self.emptyView = emptyView
        self.errorView = errorView
    }

    var body: some View {
        switch model {
        case .initial(let placeholder):
            content(placeholder)
                .redacted(reason: .placeholder)
                .disabled(true)
        case .loaded(let data):
            content(data)
        case .empty:
            emptyView()
        case .error:
            errorView()
        }
    }

}
