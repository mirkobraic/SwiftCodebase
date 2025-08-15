//
//  ViewController.swift
//  ExpandableStackButton
//
//  Created by Mirko Braic on 20.06.2023..
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    private let expandableStackButton = ExpandableStackButton(buttonSize: 40)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupExpandableStackButton()
    }

    private func setupExpandableStackButton() {
        expandableStackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(expandableStackButton)
        
        NSLayoutConstraint.activate([
            expandableStackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            expandableStackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180)
        ])
        
        // Configure the expandable stack button with different button configurations
        let configurations = [
            ExpandableStackButton.ButtonConfiguration(
                title: "Triple",
                direction: .left,
                buttonConfigurations: [
                    ExpandableButton.Configuration(image: UIImage(systemName: "bicycle")) {
                        print("button 1 selected")
                    },
                    ExpandableButton.Configuration(image: UIImage(systemName: "x.circle.fill")) {
                        print("button 2 selected")
                    },
                    ExpandableButton.Configuration(image: UIImage(systemName: "figure.gymnastics")) {
                        print("button 3 selected")
                    }
                ]
            ),
            ExpandableStackButton.ButtonConfiguration(
                title: "Single",
                direction: .left,
                buttonConfigurations: [
                    ExpandableButton.Configuration(image: UIImage(systemName: "airplane")) {
                        print("airplane tapped")
                    }
                ]
            ),
            ExpandableStackButton.ButtonConfiguration(
                title: "Double",
                direction: .left,
                buttonConfigurations: [
                    ExpandableButton.Configuration(image: UIImage(systemName: "book")) {
                        print("book selected")
                    },
                    ExpandableButton.Configuration(image: UIImage(systemName: "car")) {
                        print("car selected")
                    }
                ]
            )
        ]
        
        expandableStackButton.configure(with: configurations)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }

    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: ViewController())
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

        typealias UIViewControllerType = UIViewController
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
