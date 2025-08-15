//
//  ExpandableStackButton.swift
//  ExpandableStackButton
//
//  Created by Mirko Braic on 20.06.2023..
//

import UIKit

class ExpandableStackButton: UIView {
    
    struct ButtonConfiguration {
        let title: String?
        let direction: ExpandableButton.ExpandingDirection
        let buttonConfigurations: [ExpandableButton.Configuration]
        
        init(title: String? = nil, direction: ExpandableButton.ExpandingDirection = .left, buttonConfigurations: [ExpandableButton.Configuration]) {
            self.title = title
            self.direction = direction
            self.buttonConfigurations = buttonConfigurations
        }
    }
    
    private let stackView = UIStackView()
    private let toggleButton: ToggleButton
    private var expandableButtons: [ExpandableButton] = []
    private let buttonSize: Int
    
    init(buttonSize: Int = 40) {
        self.buttonSize = buttonSize
        self.toggleButton = ToggleButton(buttonSize: buttonSize)
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with configurations: [ButtonConfiguration]) {
        // Remove existing expandable buttons
        expandableButtons.forEach { $0.removeFromSuperview() }
        expandableButtons.removeAll()
        
        // Create new expandable buttons
        for config in configurations {
            let expandableButton = ExpandableButton(buttonSize: buttonSize)
            expandableButton.configure(
                title: config.title,
                direction: config.direction,
                buttonConfigurations: config.buttonConfigurations
            )
            expandableButton.isHidden = true
            expandableButton.alpha = 0
            expandableButtons.append(expandableButton)
            stackView.insertArrangedSubview(expandableButton, at: 0)
        }
        
        // Setup toggle button closure
        toggleButton.toggleClosure = { [weak self] isOn in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2) {
                self.expandableButtons.forEach { button in
                    button.isHidden = !isOn
                    button.alpha = isOn ? 1 : 0
                }
            }
        }
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        stackView.addArrangedSubview(toggleButton)
    }
}
