//
//  ButtonConfiguration.swift
//  ExpandableStackButton
//
//  Created by Mirko Braić on 15.08.2025..
//

import SwiftUI

struct ExpandableButtonSwiftUI: View {
    let buttonSize: CGFloat
    let title: String?
    let buttonConfigurations: [ButtonConfiguration]
    
    @State private var stackState: StackState
    @State private var selectedConfiguration: ButtonConfiguration

    init(
        buttonSize: CGFloat,
        title: String?,
        buttonConfigurations: [ButtonConfiguration]
    ) {
        assert(!buttonConfigurations.isEmpty)

        self.buttonSize = buttonSize
        self.title = title
        self.buttonConfigurations = buttonConfigurations
        if buttonConfigurations.count == 1 {
            stackState = .single
        } else {
            stackState = .collapsed
        }
        selectedConfiguration = buttonConfigurations.first!
    }

    var body: some View {
        button(config: selectedConfiguration)
            .shadow(radius: 8)
            .overlay(alignment: .trailing) {
                Text(title ?? "")
                    .opacity(stackState == .collapsed ? 1 : 0)
                    .padding(.trailing, buttonSize + 8)
                    .fixedSize()
            }
            .overlay(alignment: .trailing) {
                allButtons
                    .opacity(stackState == .expanded ? 1 : 0)
            }
    }

    var allButtons: some View {
        HStack(spacing: 0) {
            ForEach(buttonConfigurations) { config in
                button(config: config)
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 8)
    }

    func handleImageTap() {
        switch stackState {
        case .expanded:
            withAnimation {
                stackState = .collapsed
            }
            selectedConfiguration.action()
        case .collapsed:
            withAnimation {
                stackState = .expanded
            }
        case .single:
            selectedConfiguration.action()
        }
    }

    func button(config: ButtonConfiguration) -> some View {
        Button {
            selectedConfiguration = config
            handleImageTap()
        } label: {
            config.image
                .frame(width: buttonSize, height: buttonSize)
                .background(Color.white)
                .cornerRadius(8)
        }
    }
}

struct ButtonConfiguration: Identifiable {
    let id = UUID()
    let image: Image
    let action: () -> Void
}

struct ExpandableButtonSwiftUIConfiguration {
    let title: String?
    let buttonConfigurations: [ButtonConfiguration]

    init(title: String? = nil, buttonConfigurations: [ButtonConfiguration]) {
        self.title = title
        self.buttonConfigurations = buttonConfigurations
    }
}

enum StackState {
    case expanded
    case collapsed
    case single

    mutating func toggle() {
        switch self {
        case .collapsed:
            self = .expanded
        case .expanded:
            self = .collapsed
        case .single:
            self = .single
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        ExpandableButtonSwiftUI(
            buttonSize: 44,
            title: "Actions",
            buttonConfigurations: [
                ButtonConfiguration(image: Image(systemName: "star")) {
                    print("Star tapped")
                },
                ButtonConfiguration(image: Image(systemName: "heart")) {
                    print("Heart tapped")
                },
                ButtonConfiguration(image: Image(systemName: "flag")) {
                    print("Flag tapped")
                }
            ]
        )

        ExpandableButtonSwiftUI(
            buttonSize: 44,
            title: "Actions",
            buttonConfigurations: [
                ButtonConfiguration(image: Image(systemName: "book")) {
                    print("Book tapped")
                }
            ]
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
}
