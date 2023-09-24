//
//  SearchViewController.swift
//  GithubFollowers
//
//  Created by Aleksandr Fedorov on 09.05.23.
//

import UIKit

protocol SearchViewOutput {
    func didTapSearchButton(username: String)
}

final class SearchViewController: UIViewController {
    
    var output: SearchViewOutput?
    
    private lazy var searchButton: BigButton = {
        let button = BigButton(title: "Get Followers")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Username",
                                                             attributes: [.foregroundColor : UIColor.placeholderText])
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        textField.backgroundColor = .secondarySystemBackground
        
        textField.returnKeyType = .search
        textField.autocapitalizationType = .none
        
        textField.delegate = self
        return textField
    }()
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "main_logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
            
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textField.resignFirstResponder()
        textField.text = nil
        updateStateSearchButton(nil)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 58),
            searchButton.widthAnchor.constraint(equalToConstant: 345),
            
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 64),
            
            imageView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            imageView.widthAnchor.constraint(equalToConstant: 220),
        ])
        
        searchButton.addAction(.init(handler: { [weak self] _ in
            self?.output?.didTapSearchButton(username: self?.textField.text ?? "")
        }), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        updateStateSearchButton()
    }
    
    @objc private func didTapOnView(_ sender: UIView) {
        textField.resignFirstResponder()
    }
    
    private func updateStateSearchButton(_ text: String? = nil) {
        searchButton.isEnabled = (text ?? "").isValidGitHubUsername
    }
}

extension SearchViewController: UITextFieldDelegate {
            
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateStateSearchButton(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard (textField.text ?? "").isValidGitHubUsername else {
            let alert = UIAlertController(title: "Username is not valid",
                                          message: "Please, input a valid username. For more information see the official documentation.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default) { _ in })
            present(alert, animated: true)
            return false
        }
        textField.resignFirstResponder()
        output?.didTapSearchButton(username: textField.text ?? "")
        return true
    }
}

extension SearchViewController: SearchPresenterOutput {
    
    func showSearchResults(searchedUsername: String) {
        let searchResultsViewController = SearchResultsAssembly.makeModule(searchedUsername: searchedUsername)
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
}
