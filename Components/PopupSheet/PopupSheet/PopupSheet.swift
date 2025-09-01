import SwiftUI

extension View {

    /// Presents content in a popup sheet with a fade transition.
    ///
    /// This function emulates the behavior of a sheet view, but it does it with an opacity transition,
    /// instead of slide from the bottom. Internally it uses fullScreenCover to achieve this.
    ///
    /// The popup sheet displays the provided content in the center of the screen with a darkened background.
    /// It includes a close button in the top-right corner and animates its appearance. Dissmiss animation is still missing.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional value that determines whether to present the sheet.
    ///   - onDismiss: An optional action to perform when the sheet is dismissed.
    ///   - content: A closure returning the content view to display in the popup.
    ///
    /// - Returns: A view that presents the content as a popup sheet when the item is non-nil.
    public func popupSheet<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        fullScreenCover(item: item, onDismiss: onDismiss) { item in
            PopupSheetView {
                content(item)
            }
        }
        .transaction { $0.disablesAnimations = true }
    }

}

public struct PopupSheetView<Content: View>: View {

    @Environment(\.dismiss) private var dismiss
    @State private var isShowing = false

    private let content: () -> Content
    private let animationDuration = 0.25
    private let padding = 8.0

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        ZStack {
            if isShowing {
                Color.clear
                    .contentShape(.rect)
                    .onTapGesture { animatedDismiss() }

                content()
                    .background(Color.white)
                    .cornerRadius(4)
                    .overlay(alignment: .topTrailing) {
                        closeButton
                            .padding(padding)
                    }
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 1.05)
                                .combined(with: .opacity)
                                .animation(.easeOut(duration: animationDuration)),
                            removal: .opacity.animation(.easeOut(duration: animationDuration))
                        )
                    )
            }
        }
        .ignoresSafeArea()
        .presentationBackground(isShowing ? Color.black.opacity(0.6) : .clear)
        .onAppear { withAnimation(.easeOut(duration: animationDuration)) { isShowing = true } }
        .onDisappear { withAnimation(.easeOut(duration: animationDuration)) { isShowing = false } }
    }

    private var closeButton: some View {
        Button {
            animatedDismiss()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.black)
                .frame(width: 15, height: 15)
        }
        .frame(width: 44, height: 44)
    }

    private func animatedDismiss() {
        withAnimation(.easeOut(duration: animationDuration)) {
            isShowing = false
        } completion: {
            dismiss()
        }
    }

}
