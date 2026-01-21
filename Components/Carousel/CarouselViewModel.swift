import SwiftUI

@Observable
class CarouselViewModel {

    var showsBottomControls: Bool
    var tabViewIndex: Int

    private let views: [AnyView]
    /// Contains a list of original views but adds the last view at the first position and the first view at the last position.
    /// This creates a looping effect, making the carousel appear infinite.
    /// Example: Given views [A, B, C], fakedViews will be [C, A, B, C, A].
    private let fakedViews: [AnyView]
    private let viewTitles: [String]
    private let supportsLooping: Bool

    var viewCount: Int { fakedViews.count }
    var pageIndicatorCount: Int { views.count }

    var nextPageTitle: String { getTitle(for: pageIndicatorIndex + 1) }
    var previousPageTitle: String { getTitle(for: pageIndicatorIndex - 1) }

    var showsNextButton: Bool { supportsLooping || pageIndicatorIndex != views.count - 1 }
    var showsPreviousButton: Bool { supportsLooping || pageIndicatorIndex != 0 }

    /// The adjusted index for the page indicator.
    var pageIndicatorIndex: Int {
        guard supportsLooping else { return tabViewIndex }

        if tabViewIndex <= 0 {
            return views.count - 1
        } else if tabViewIndex >= fakedViews.count - 1 {
            return 0
        } else {
            return tabViewIndex - 1
        }
    }

    init(views: [AnyView], viewTitles: [String]) {
        self.views = views
        self.viewTitles = viewTitles

        supportsLooping = views.count > 2
        showsBottomControls = views.count > 1

        if supportsLooping {
            fakedViews = ([views.last] + views + [views.first]).compactMap { $0 }
            tabViewIndex = 1
        } else {
            fakedViews = views
            tabViewIndex = 0
        }
    }

    func view(at index: Int) -> AnyView? {
        fakedViews[safe: index]
    }

    func nextPage() {
        tabViewIndex += 1
    }

    func previousPage() {
        tabViewIndex -= 1
    }

    /// Adjusts `tabViewIndex` to endable infinite scrolling behavior.
    /// This function ensures that the `tabViewIndex` always points to a valid "real" view in the carousel.
    /// When index reaches a "fake" view, it is reset to its "real" view counterpart.
    func pageDisappeared() {
        guard supportsLooping else { return }

        if tabViewIndex <= 0 {
            tabViewIndex = views.count
        } else if tabViewIndex >= fakedViews.count - 1 {
            tabViewIndex = 1
        }
    }

    private func getTitle(for index: Int) -> String {
        let count = views.count
        // Wrap the index to support looping behavior.
        let wrappedIndex = (index % count + count) % count

        return viewTitles[safe: wrappedIndex] ?? ""
    }

}
