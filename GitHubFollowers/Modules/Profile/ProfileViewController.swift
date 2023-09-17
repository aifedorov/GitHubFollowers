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
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Aleksandr Fedorov"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .brandColor
        label.textAlignment = .left
        return label
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "aifedorov"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .placeholderText
        label.textAlignment = .left
        return label
    }()
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "5 followers · 5 following"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .brandColor
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
    private lazy var openProfileButton: BigButton = {
        let button = BigButton(title: "Open Profile", isShowArrow: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var addToFavoriteButton: BigButton = {
        let button = BigButton(title: "Add to Favorites", isShowArrow: false, backgroundColor: .favoriteColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .accentColor
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
        
        view.addSubview(avatarImageView)
        view.addSubview(nameStackView)

        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(usernameLabel)
        view.addSubview(followersLabel)
        
        buttonsStackView.addArrangedSubview(openProfileButton)
        buttonsStackView.addArrangedSubview(addToFavoriteButton)
        view.addSubview(buttonsStackView)
        
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 180),
            avatarImageView.widthAnchor.constraint(equalToConstant: 180),
            
            nameStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            nameStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nameStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 30),
            
            followersLabel.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 10),
            followersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            followersLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 30),
            
            openProfileButton.heightAnchor.constraint(equalToConstant: 52),
            addToFavoriteButton.heightAnchor.constraint(equalToConstant: 52),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
