//
//  StateView.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 08.07.23.
//

import UIKit

final class FullsScreenMessageView: UIView {
    
    private let text: String
    private let buttonTitle: String
    private let buttonAction: () -> ()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 24)
        label.textColor = .placeholderText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var actionButton: BigButton = {
        let button = BigButton(title: self.buttonTitle)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(with text: String, buttonTitle: String, buttonAction: @escaping () -> ()) {
        self.text = text
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String) {
        textLabel.text = text
    }
    
    private func setupView() {
        addSubviews([textLabel, actionButton])
        
        actionButton.fixSize(width: 240, height: 52)
        actionButton.pinToCenterSuperview(centerX: 0)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 170),
            textLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            actionButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 32),
        ])
        
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapActionButton(_ sender: UIButton) {
        buttonAction()
    }
}
