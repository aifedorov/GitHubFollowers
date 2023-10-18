//
//  CGAlertViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 28.09.23.
//

import UIKit

final class GFAlertViewController: UIViewController {
    
    enum AlertType {
        case success
        case error
    }
    
    private let alertTitle: String
    private let message: String
    private let buttonTitle: String
    
    private lazy var titleLabel: CGTitleLabel = {
        CGTitleLabel(text: alertTitle)
    }()
        
    private lazy var messageLabel: GFBodyLabel = {
        GFBodyLabel(text: message)
    }()
    
    private lazy var actionButton: GFButton = {
        GFButton(title: buttonTitle)
    }()
    
    private lazy var alertContainerView: UIView = {
        let alertContainerView = UIView()
        alertContainerView.translatesAutoresizingMaskIntoConstraints = false
        alertContainerView.layer.shadowColor = UIColor.black.cgColor
        alertContainerView.layer.shadowOffset  = .init(width: 0, height: 8)
        alertContainerView.layer.shadowOpacity = 0.5
        alertContainerView.layer.shadowRadius = 20
        alertContainerView.backgroundColor = .systemBackground
        alertContainerView.layer.cornerRadius = 12
        return alertContainerView
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    init(alertTitle: String, message: String, buttonTitle: String = "ok", type: AlertType) {
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
        
        super.init(nibName: nil, bundle: nil)
        
        actionButton.backgroundColor = makeButtonBackground(type)
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func makeButtonBackground(_ type: AlertType) -> UIColor {
        switch type {
        case .success:
            return .systemGreen
        case .error:
            return .systemRed
        }
    }
    
    @objc private func didTapActionButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visualEffectView.frame = view.bounds
    }
    
    private func setupViews() {
        view.addSubviews([visualEffectView, alertContainerView])
        alertContainerView.addSubviews([titleLabel, messageLabel, actionButton])
        
        alertContainerView.pinToCenterSuperview(centerX: 0, centerY: 0)

        titleLabel.pinToEdgesSuperview(top: 16, leading: 24, trailing: -24, withSafeArea: false)
        messageLabel.pinToEdgesSuperview(leading: 24, trailing: -24, withSafeArea: false)

        actionButton.pinToEdgesSuperview(leading: 24, trailing: -24, bottom: -16,  withSafeArea: false)
        actionButton.fixSize(width: 248, height: 44)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16)
        ])
    }
}
