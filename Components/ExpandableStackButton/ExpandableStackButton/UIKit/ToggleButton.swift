//
//  ToggleButton.swift
//  ExpandableStackButton
//
//  Created by Mirko Braic on 20.06.2023..
//

import UIKit

class ToggleButton: UIView {
    private let button = UIButton()
    private let iconView = UIImageView()

    private var onImage = UIImage(systemName: "circle.fill")
    private var offImage = UIImage(systemName: "circle")
    private var isOn = false
    private let buttonSize: Int

    var toggleClosure: ((Bool) -> Void)?

    init(buttonSize: Int) {
        self.buttonSize = buttonSize
        super.init(frame: .zero)
        setupView()
        setupIconView()
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func toggleSelection() {
        isOn.toggle()
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = self.isOn ? .systemGray3 : .white
        }
        UIView.transition(with: self.iconView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            self.iconView.image = self.isOn ? self.onImage : self.offImage
        }, completion: nil)
        toggleClosure?(isOn)
    }
}

// MARK: UI Setup
extension ToggleButton {
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: CGFloat(buttonSize)),
            widthAnchor.constraint(equalToConstant: CGFloat(buttonSize))
        ])
    }
    private func setupIconView() {
        iconView.image = offImage
        iconView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    private func setupButton() {
        button.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
