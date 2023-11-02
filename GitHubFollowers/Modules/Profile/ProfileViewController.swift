//
//  ProfileViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 30.08.23.
//

import UIKit

protocol ProfileViewOutput: AnyObject {
    func didTapOpenProfileButton()
    func didTapAddToFavoriteButton()
    func viewDidLoad()
}

final class ProfileViewController: UIViewController {
    
    struct DisplayData {
        let fullName: String
        let followers: GFBlockView.DisplayData
        let noFollowers: Bool
        let repos: GFBlockView.DisplayData
        let onGitHubSince: String
    }
    
    var output: ProfileViewOutput?
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .avatarPlaceholder)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let fullNameLabel: GFHeadLineTitleLabel = {
        let label = GFHeadLineTitleLabel(text: "No name")
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let usernameLabel: GFUsernameLabel = {
        let label = GFUsernameLabel()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var followersBlockView = GFBlockView()
    private lazy var reposBlockView = GFBlockView()
    private lazy var blocksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var onGitHubSinceLabel: GFBodyLabel = {
        let label = GFBodyLabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loadingView = GFLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        output?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.height / 2
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        userInfoStackView.addArrangedSubview(fullNameLabel)
        userInfoStackView.addArrangedSubview(usernameLabel)
        
        blocksStackView.addArrangedSubview(followersBlockView)
        blocksStackView.addArrangedSubview(reposBlockView)
        
        view.addSubviews([avatarImageView, userInfoStackView, blocksStackView, onGitHubSinceLabel, loadingView])
        
        avatarImageView.pinToEdgesSuperview(top: 16, withSafeArea: true)
        avatarImageView.pinToCenterSuperview(centerX: 0)
        avatarImageView.fixSize(width: 120, height: 120)
        
        userInfoStackView.pinToEdgesSuperview(leading: 40, trailing: 40, withSafeArea: true)
        
        loadingView.pinToCenterSuperview(centerX: 0, centerY: 0)
        
        followersBlockView.fixSize(height: 130)
        reposBlockView.fixSize(height: 130)
        blocksStackView.pinToEdgesSuperview(leading: 40, trailing: 40, withSafeArea: true)
        
        onGitHubSinceLabel.pinToEdgesSuperview(leading: 40, trailing: 40, bottom: 16, withSafeArea: true)
        
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            blocksStackView.topAnchor.constraint(equalTo: userInfoStackView.bottomAnchor, constant: 24),
            onGitHubSinceLabel.topAnchor.constraint(greaterThanOrEqualTo: blocksStackView.bottomAnchor, constant: 16)
        ])
    }
}

extension ProfileViewController: ProfilePresenterOutput {
    
    func updateUserAvatar(withImageData imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        avatarImageView.image = image
    }
    
    func showUserInfo(_ displayData: DisplayData) {
        if !displayData.fullName.isEmpty {
            fullNameLabel.text = displayData.fullName
        }
        
        if displayData.noFollowers {
            // TODO: Disable button open profile
        } else {
            followersBlockView.configure(with: displayData.followers)
        }
        
        reposBlockView.configure(with: displayData.repos)
        onGitHubSinceLabel.text = displayData.onGitHubSince
        
        UIView.animate(withDuration: 0.3) {
            self.fullNameLabel.alpha = 1
            self.followersBlockView.alpha = 1
            self.reposBlockView.alpha = 1
            self.onGitHubSinceLabel.alpha = 1
        }
        
        UIView.transition(with: usernameLabel,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            self.usernameLabel.textAlignment = .left
        }, completion: nil)
    }
    
    func setupInitialState(username: String) {
        usernameLabel.textAlignment = .center
        usernameLabel.text = username
        
        self.fullNameLabel.alpha = 0
        self.followersBlockView.alpha = 0
        self.reposBlockView.alpha = 0
        self.onGitHubSinceLabel.alpha = 0
    }
    
    func showLoadingView() {
        loadingView.isHidden = false
        loadingView.startLoading()
    }
    
    func hideLoadingView() {
        loadingView.isHidden = true
        loadingView.stopLoading()
    }
    
    func showErrorAlert(title: String, message: String) {
        presentAlert(title: title, message: message, type: .error)
    }
}
