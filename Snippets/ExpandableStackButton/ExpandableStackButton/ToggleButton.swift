//
//  ToggleButton.swift
//  ExpandableStackButton
//
//  Created by Mirko Braic on 20.06.2023..
//

import UIKit
import SnapKit

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
        snp.makeConstraints { make in
            make.height.width.equalTo(buttonSize)
        }
    }
    private func setupIconView() {
        iconView.image = offImage

        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    private func setupButton() {
        button.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)

        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
