import SwiftUI
import Core

public struct CollapsingHeaderScrollView<Header: View, Content: View>: View {

    private let config: CollapsingHeaderScrollViewConfiguration
    private let header: Header
    private let content: Content

    @Binding private var progress: CGFloat
    @Binding private var isRefreshing: Bool
    /// Used to ensure that the ProgressView always gets animated
    @State private var isRefreshingInternal: Bool = false

    public init(
        config: CollapsingHeaderScrollViewConfiguration,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.config = config
        self.header = header()
        self.content = content()

        _progress = config.progressBinding ?? .constant(.zero)
        _isRefreshing = config.refreshingBinding ?? .constant(false)
    }

    public var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(showsIndicators: false) {
                ZStack {
                    GeometryReader { insideProxy in
                        let scrollOffset = outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
                        collapsableHeader(for: scrollOffset)
                            .preference(key: ScrollOffsetPreferenceKey.self, value: scrollOffset)
                    }
                    .zIndex(1)
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) {
                        updateBindings(for: $0)
                    }
                    .onChange(of: isRefreshing) { _, newValue in
                        withAnimation { isRefreshingInternal = newValue }
                    }

                    VStack(spacing: 0) {
                        fillerView

                        if isRefreshingInternal, config.enableRefreshProgressView {
                            ProgressView()
                                .padding(.vertical)
                                .transition(.move(edge: .top))
                        }

                        content
                    }
                }
            }
            .bounces(!config.disableBounce && config.initialDataLoaded)
        }
    }

    /// Creates empty space at the top of a ScrollView that matches the height of the header
    private var fillerView: some View {
        Color.clear
            .frame(height: config.maxHeaderHeight)
    }

    @ViewBuilder
    private func collapsableHeader(for scrollOffset: CGFloat) -> some View {
        switch config.collapseStyle {
        case .standard, .fixed:
            header
                .frame(height: headerHeight(for: scrollOffset))
                .offset(y: headerOffset(for: scrollOffset))
        case .compress(let alignment):
            header
                .frame(height: headerHeight(for: scrollOffset), alignment: alignment.headerAlignment)
                .clipped()
                .contentShape(Rectangle())
                .offset(y: headerOffset(for: scrollOffset))
        }
    }

}

// MARK: - Scroll Offset Calculations
extension CollapsingHeaderScrollView {

    private func updateBindings(for scrollOffset: CGFloat) {
        let newProgress = collapseProgress(for: scrollOffset)
        if abs(newProgress - progress) >= config.progressStep || newProgress == 1 || newProgress == 0 {
            progress = newProgress
        }

        if scrollOffset < config.refreshThreshold, config.initialDataLoaded {
            guard !isRefreshing else { return }

            isRefreshing = true
        }
    }

    private func headerOffset(for scrollOffset: CGFloat) -> CGFloat {
        // Handle pull to refresh by keeping the header stationary
        guard scrollOffset > 0 else { return scrollOffset }

        switch config.collapseStyle {
        case .standard:
            let maxAllowedOffset = config.maxHeaderHeight - config.minHeaderHeight
            return max(0, scrollOffset - maxAllowedOffset)
        case .compress:
            return scrollOffset
        case .fixed:
            return scrollOffset
        }
    }

    private func headerHeight(for scrollOffset: CGFloat) -> CGFloat {
        guard scrollOffset > 0 else { return config.maxHeaderHeight }

        switch config.collapseStyle {
        case .standard:
            return config.maxHeaderHeight
        case .compress:
            return max(config.minHeaderHeight, config.maxHeaderHeight - scrollOffset)
        case .fixed:
            return config.maxHeaderHeight
        }
    }

    private func collapseProgress(for scrollOffset: CGFloat) -> CGFloat {
        let maxCollapseRange = config.maxHeaderHeight - config.minHeaderHeight

        let scrollDifference = scrollOffset - headerOffset(for: scrollOffset)
        let currentHeaderCollapse = headerHeight(for: scrollOffset) - scrollDifference - config.minHeaderHeight
        let percentage = currentHeaderCollapse / maxCollapseRange

        return (1 - percentage).clamped(min: 0, max: 1)
    }

}
