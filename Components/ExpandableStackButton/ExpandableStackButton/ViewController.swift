//
//  ViewController.swift
//  ExpandableStackButton
//
//  Created by Mirko Braic on 20.06.2023..
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    let stackView = UIStackView()

    let toggleButton = ToggleButton(buttonSize: 40)
    let expandableButton1 = ExpandableButton(buttonSize: 40)
    let expandableButton2 = ExpandableButton(buttonSize: 40)
    let expandableButton3 = ExpandableButton(buttonSize: 40)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        setupStack()
    }

    private func configureButtons() {
        toggleButton.toggleClosure = { [weak self] isOn in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2) {
                self.expandableButton1.isHidden = !isOn
                self.expandableButton2.isHidden = !isOn
                self.expandableButton3.isHidden = !isOn
                self.expandableButton1.alpha = isOn ? 1 : 0
                self.expandableButton2.alpha = isOn ? 1 : 0
                self.expandableButton3.alpha = isOn ? 1 : 0
            }
        }

        let bikeButton = ExpandableButton.Configuration(image: UIImage(systemName: "bicycle")) {
            print("button 1 selected")
        }
        let xButton = ExpandableButton.Configuration(image: UIImage(systemName: "x.circle.fill")) {
            print("button 2 selected")
        }
        let gymButton = ExpandableButton.Configuration(image: UIImage(systemName: "figure.gymnastics")) {
            print("button 3 selected")
        }
        expandableButton1.configure(title: "Triple stack", direction: .left, buttonConfigurations: [bikeButton, xButton, gymButton])

        expandableButton2.configure(title: "Single", direction: .left, buttonConfigurations: [ExpandableButton.Configuration(image: UIImage(systemName: "airplane")) {
            print("airplane tapped")
        }])

        let bookButton = ExpandableButton.Configuration(image: UIImage(systemName: "book")) {
            print("book selected")
        }
        let carBuutton = ExpandableButton.Configuration(image: UIImage(systemName: "car")) {
            print("car selected")
        }

        expandableButton3.configure(title: "Double", direction: .left, buttonConfigurations: [bookButton, carBuutton])
    }

    private func setupStack() {
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 16

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-250)
            make.trailing.equalToSuperview().offset(-170)
        }

        expandableButton1.isHidden = true
        expandableButton2.isHidden = true
        expandableButton3.isHidden = true
        stackView.addArrangedSubview(expandableButton1)
        stackView.addArrangedSubview(expandableButton2)
        stackView.addArrangedSubview(expandableButton3)
        stackView.addArrangedSubview(toggleButton)
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
