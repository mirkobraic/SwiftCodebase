//
//  ExpandableStackButtonSwiftUI.swift
//  ExpandableStackButton
//
//  Created by Mirko Braić on 15.08.2025..
//

import SwiftUI

struct ExpandableStackButtonSwiftUI: View {
    let buttonSize: CGFloat
    let configurations: [ExpandableButtonSwiftUIConfiguration]

    @State private var isExpanded1: Bool = false
    @State private var isExpanded2: Bool = false

    init(buttonSize: CGFloat, configurations: [ExpandableButtonSwiftUIConfiguration]) {
        self.buttonSize = buttonSize
        self.configurations = configurations
    }

    init() {
        self.buttonSize = 44
        self.configurations = [
            ExpandableButtonSwiftUIConfiguration(
                title: "Share",
                buttonConfigurations: [
                    ButtonConfiguration(image: Image(systemName:"square.and.arrow.up"), action: { print("Share tapped") }),
                    ButtonConfiguration(image: Image(systemName:"envelope"), action: { print("Email tapped") }),
                    ButtonConfiguration(image: Image(systemName:"message"), action: { print("Message tapped") })
                ]
            ),
            ExpandableButtonSwiftUIConfiguration(
                title: "Edit",
                buttonConfigurations: [
                    ButtonConfiguration(image: Image(systemName:"pencil"), action: { print("Edit tapped") }),
                    ButtonConfiguration(image: Image(systemName:"trash"), action: { print("Delete tapped") })
                ]
            )
        ]
    }

    var body: some View {
        ToggleButtonSwiftUI(isOn: $isExpanded1, buttonSize: buttonSize)
            .background(alignment: .bottom) {
                VStack(spacing: isExpanded1 ? 16 : -buttonSize) {
                    ForEach(Array(configurations.enumerated()), id: \.offset) { _, config in
                        ExpandableButtonSwiftUI(
                            buttonSize: buttonSize,
                            title: config.title,
                            buttonConfigurations: config.buttonConfigurations
                        )
                    }
                }
                .padding(.bottom, buttonSize + 16)
                .opacity(isExpanded1 ? 1 : 0)
                .frame(height: isExpanded1 ? nil : 0)

            }
    }
}

#Preview {
    ZStack {
        ExpandableStackButtonSwiftUI(
            buttonSize: 44,
            configurations: [
                ExpandableButtonSwiftUIConfiguration(
                    title: "Share",
                    buttonConfigurations: [
                        ButtonConfiguration(image: Image(systemName:"square.and.arrow.up"), action: { print("Share tapped") }),
                        ButtonConfiguration(image: Image(systemName:"envelope"), action: { print("Email tapped") }),
                        ButtonConfiguration(image: Image(systemName:"message"), action: { print("Message tapped") })
                    ]
                ),
                ExpandableButtonSwiftUIConfiguration(
                    title: "Edit",
                    buttonConfigurations: [
                        ButtonConfiguration(image: Image(systemName:"pencil"), action: { print("Edit tapped") }),
                        ButtonConfiguration(image: Image(systemName:"trash"), action: { print("Delete tapped") })
                    ]
                )
            ]
        )
        .padding()

        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGray6))
}
