//
//  StateView.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 08.07.23.
//

import UIKit

final class GFFullScreenMessageView: UIView {
    
    private let title: String
    private let message: String
    private let buttonTitle: String
    private let buttonAction: () -> ()
    
    private lazy var titleLabel: CGTitleLabel = {
        let label = CGTitleLabel(text: self.title)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var messageLabel: GFBodyLabel = {
        let label = GFBodyLabel(text: self.message)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var actionButton: GFButton = {
        GFButton(title: self.buttonTitle)
    }()
    
    init(withTitle title: String, message: String, buttonTitle: String, buttonAction: @escaping () -> ()) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
    
    private func setupView() {
        addSubviews([titleLabel, messageLabel, actionButton])
        
        actionButton.fixSize(width: 240, height: 52)
        actionButton.pinToCenterSuperview(centerX: 0)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 170),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30)
        ])
        
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapActionButton(_ sender: UIButton) {
        buttonAction()
    }
}
