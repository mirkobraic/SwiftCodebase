import SwiftUI

/// A horizontally scrolling carousel that loops infinitely.
///
/// This view displays a sequence of pages that can be scrolled left or right.
/// It has a custom paging indicator and back and forward buttons that can be customized with a title.
public struct CarouselView: View {

    @State var viewModel: CarouselViewModel
    private let padding: Double

    /// Initializes the carousel with multiple views.
    ///
    /// - Parameters:
    ///   - padding: Spacing between elements.
    ///   - views: A list of child views.
    ///   - titles: A list of titles for each view (default is empty).
    public init(padding: Double, views: [any View], titles: [String] = []) {
        self.padding = padding
        viewModel = CarouselViewModel(views: views.map { AnyView($0) }, viewTitles: titles)
    }

    public var body: some View {
        VStack(spacing: .gutter(withMultiplier: 3)) {
            HeightPreservingTabView(selection: $viewModel.tabViewIndex) {
                ForEach(0 ..< viewModel.viewCount, id: \.self) { index in
                    viewModel.view(at: index)
                        .maxHeight(alignment: .top)
                        .padding(.horizontal, .gutter(withMultiplier: 5))
                        .onDisappear(perform: viewModel.pageDisappeared)

                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            if viewModel.showsBottomControls {
                bottomControls
                    .padding(.horizontal, padding)
            }
        }
        .padding(.vertical, padding)
        .maxWidth()
        .background(Color.primaryWhite)
    }

    private var bottomControls: some View {
        HStack(spacing: .doubleGutter) {
            previousPageButton
                .opacity(viewModel.showsPreviousButton ? 1 : 0)
                .animation(nil, value: viewModel.showsPreviousButton)

            PageIndicator(
                selectedIndex: viewModel.pageIndicatorIndex,
                numberOfDots: viewModel.pageIndicatorCount,
                inactiveColor: .dividerBackground
            )

            nextPageButton
                .opacity(viewModel.showsNextButton ? 1 : 0)
                .animation(nil, value: viewModel.showsNextButton)
        }
    }

    private var previousPageButton: some View {
        ThrottledButton(throttleTime: 0.4) {
            withAnimation {
                viewModel.previousPage()
            }
        } label: {
            HStack(spacing: .doubleGutter) {
                Image.iconChevronLeft
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(viewModel.previousPageTitle)
                    .font(.fontHeading5)
                    .foregroundStyle(Color.lightTextPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .animation(nil, value: viewModel.tabViewIndex)
            }
            .maxWidth(alignment: .leading)
            .frame(minHeight: 40)
        }
    }

    private var nextPageButton: some View {
        ThrottledButton(throttleTime: 0.4) {
            withAnimation {
                viewModel.nextPage()
            }
        } label: {
            HStack(spacing: .doubleGutter) {
                Text(viewModel.nextPageTitle)
                    .font(.fontHeading5)
                    .foregroundStyle(Color.lightTextPrimary)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
                    .animation(nil, value: viewModel.tabViewIndex)

                Image.iconChevronRight
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .maxWidth(alignment: .trailing)
            .frame(minHeight: 40)
        }
    }

}
