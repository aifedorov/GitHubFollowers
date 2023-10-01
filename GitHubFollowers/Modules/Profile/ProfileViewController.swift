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
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel = GFHeadLineTitleLabel(text: "Aleksandr Fedorov")
    private let usernameLabel = GFUsernameLabel(text: "aifedorov")
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "5 followers · 5 following"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .brand
        label.textAlignment = .left
        return label
    }()
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private lazy var openProfileButton: GFButton = {
        let button = GFButton(title: "Open Profile")
        return button
    }()
    private lazy var addToFavoriteButton: GFButton = {
        let button = GFButton(title: "Add to Favorites", backgroundColor: .favorite)
        return button
    }()
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .accent
        return loadingView
    }()
    
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
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(usernameLabel)
        view.addSubview(followersLabel)
        
        buttonsStackView.addArrangedSubview(openProfileButton)
        buttonsStackView.addArrangedSubview(addToFavoriteButton)
        
        view.addSubviews([avatarImageView, nameStackView, buttonsStackView, loadingView])
        
        avatarImageView.pinToEdgesSuperview(top: 60)
        avatarImageView.pinToCenterSuperview(centerX: 0)
        avatarImageView.fixSize(width: 180, height: 180)
        
        nameStackView.pinToEdgesSuperview(leading: 30, trailing: 30)
        followersLabel.pinToEdgesSuperview(leading: 30, trailing: 30)
        openProfileButton.fixSize(height: 52)
        addToFavoriteButton.fixSize(height: 52)
        
        buttonsStackView.pinToEdgesSuperview(leading: 24, trailing: 24, bottom: 24)
        
        loadingView.pinToCenterSuperview(centerX: 0, centerY: 0)
        
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            followersLabel.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 10),
        ])
        
        openProfileButton.addAction(.init(handler: { [weak self] _ in
            self?.output?.didTapOpenProfileButton()
        }), for: .touchUpInside)
        
        addToFavoriteButton.addAction(.init(handler: { [weak self] _ in
            self?.output?.didTapAddToFavoriteButton()
        }), for: .touchUpInside)
    }
    
    func configure(with user: User) {
        usernameLabel.text = user.login
    }
}

extension ProfileViewController: ProfilePresenterOutput {
    
    func showLoadingView() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.stopAnimating()
    }
}
