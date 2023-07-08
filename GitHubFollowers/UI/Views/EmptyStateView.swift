//
//  EmptyStateView.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 08.07.23.
//

import UIKit

final class EmptyStateView: UIView {
    
    private let text: String
    private let buttonAction: () -> ()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 32)
        label.textColor = .placeholderTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var actionButton: BigButton = {
        let button = BigButton(title: "Open search screen", isShowArrow: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(with text: String, buttonAction: @escaping () -> ()) {
        self.text = text
        self.buttonAction = buttonAction
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(textLabel)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 170),
            textLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            actionButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 32),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 240),
            actionButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapActionButton(_ sender: UIButton) {
        buttonAction()
    }
}
