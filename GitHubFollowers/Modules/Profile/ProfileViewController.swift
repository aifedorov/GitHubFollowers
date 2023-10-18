//
//  ProfileViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 30.08.23.
//

import UIKit

protocol ProfileViewOutput {
    func didTapOpenProfileButton()
    func didTapAddToFavoriteButton()
    func viewDidLoad()
}

final class ProfileViewController: UIViewController {
    var output: ProfileViewOutput?
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .avatarPlaceholder)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel = GFHeadLineTitleLabel()
    private let usernameLabel = GFUsernameLabel()
    private let bioLabel = GFBodyLabel()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "5 followers · 5 following"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .brand
        label.textAlignment = .left
        return label
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let loadingView = GFLoadingView()
    
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
        
        userInfoStackView.addArrangedSubview(nameLabel)
        userInfoStackView.addArrangedSubview(usernameLabel)
        view.addSubviews([avatarImageView, userInfoStackView, loadingView])
        
        avatarImageView.pinToEdgesSuperview(top: 16, withSafeArea: true)
        avatarImageView.pinToCenterSuperview(centerX: 0)
        avatarImageView.fixSize(width: 120, height: 120)
        
        userInfoStackView.pinToEdgesSuperview(leading: 30, trailing: 30)
        
        loadingView.pinToCenterSuperview(centerX: 0, centerY: 0)
        
        NSLayoutConstraint.activate([
            userInfoStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24)
        ])
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        usernameLabel.text = user.login
        bioLabel.text = user.bio
    }
}

extension ProfileViewController: ProfilePresenterOutput {
    
    func showLoadingView() {
        loadingView.isHidden = false
        loadingView.startLoading()
    }
    
    func hideLoadingView() {
        loadingView.isHidden = true
        loadingView.stopLoading()
    }
}
