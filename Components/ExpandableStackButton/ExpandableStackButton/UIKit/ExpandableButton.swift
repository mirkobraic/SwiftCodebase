//
//  ExpandableButton.swift
//  ExpandableStackButton
//
//  Created by Mirko Braic on 20.06.2023..
//

import UIKit

class CallbackButton: UIButton {
    var tapCallback: (() -> Void)?
}

class ExpandableButton: UIView {
    struct Configuration {
        let image: UIImage?
        let tapCallback: () -> Void
    }

    enum ExpandingDirection {
        case left
        case right
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

    var isEnabled: Bool = true {
        didSet {
            backgroundColor = isEnabled ? .white : .lightGray
            selectedIcon.backgroundColor = isEnabled ? .white : .lightGray
            selectedIcon.tintColor = isEnabled ? .darkGray : .lightGray
            isUserInteractionEnabled = isEnabled
        }
    }

    private let stackView = UIStackView()
    private let selectedIcon = UIImageView()
    private var titleLabel: UILabel?
    private var mainButton: CallbackButton!
    private var buttons = [CallbackButton]()

    private var stackState = StackState.collapsed
    private let buttonSize: Int

    init(buttonSize: Int) {
        self.buttonSize = buttonSize
        super.init(frame: .zero)

        backgroundColor = .white
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.cornerRadius = 8

        setupStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String?, direction: ExpandingDirection, buttonConfigurations: [Configuration]) {
        assert(buttonConfigurations.isEmpty == false)
        if buttonConfigurations.count == 1 {
            stackState = .single
        }

        for configuration in buttonConfigurations {
            buttons.append(makeButtonWithConfiguration(configuration))
        }
        mainButton = buttons.first
        mainButton.isHidden = false
        selectedIcon.image = mainButton.imageView?.image

        if direction == .left {
            buttons.reversed().forEach { stackView.addArrangedSubview($0) }
        } else {
            buttons.forEach { stackView.addArrangedSubview($0) }
        }

        setupSelectedIconView(forDirection: direction)
        if let title = title {
            setupTitleLabel(title: title, forDirection: direction)
        }
    }

    private func makeButtonWithConfiguration(_ configuration: Configuration) -> CallbackButton {
        let button = CallbackButton()
        button.tapCallback = configuration.tapCallback
        button.setImage(configuration.image, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize)),
            button.heightAnchor.constraint(equalToConstant: CGFloat(buttonSize))
        ])
        button.isHidden = true
        return button
    }

    @objc private func didTapButton(sender: CallbackButton) {
        if stackState == .single {
            sender.tapCallback?()
        } else {
            if stackState == .expanded {
                sender.tapCallback?()
                selectedIcon.image = sender.imageView?.image
            }
            toggleStack()
        }
    }

    private func toggleStack() {
        guard stackState != .single else { return }

        stackState.toggle()
        let isStackExpanded = stackState == .expanded
        UIView.animate(withDuration: 0.2) {
            self.buttons[1...].forEach {
                $0.isHidden = isStackExpanded ? false : true
                $0.alpha = isStackExpanded ? 1 : 0
            }
            self.selectedIcon.alpha = isStackExpanded ? 0 : 1
            self.titleLabel?.alpha = isStackExpanded ? 0 : 1
        }
    }
}

// MARK: UI Setup
extension ExpandableButton {
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupSelectedIconView(forDirection direction: ExpandingDirection) {
        selectedIcon.layer.cornerRadius = 8
        selectedIcon.backgroundColor = .white
        selectedIcon.contentMode = .scaleAspectFit
        selectedIcon.translatesAutoresizingMaskIntoConstraints = false

        addSubview(selectedIcon)
        
        var constraints = [
            selectedIcon.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            selectedIcon.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize))
        ]
        
        if direction == .left {
            constraints.append(selectedIcon.trailingAnchor.constraint(equalTo: stackView.trailingAnchor))
        } else {
            constraints.append(selectedIcon.leadingAnchor.constraint(equalTo: stackView.leadingAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }

    private func setupTitleLabel(title: String, forDirection direction: ExpandingDirection) {
        titleLabel = UILabel()
        guard let titleLabel = titleLabel else { return }
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 13)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        
        var constraints = [
            titleLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ]
        
        if direction == .left {
            constraints.append(titleLabel.trailingAnchor.constraint(equalTo: selectedIcon.leadingAnchor, constant: -10))
        } else {
            constraints.append(titleLabel.leadingAnchor.constraint(equalTo: selectedIcon.trailingAnchor, constant: 10))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}

