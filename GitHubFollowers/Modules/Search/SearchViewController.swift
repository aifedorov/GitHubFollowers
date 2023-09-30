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
    
    private lazy var searchButton: GFButton = {
        GFButton(title: "Get Followers")
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
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
        view.addSubviews([imageView, textField, searchButton])
        
        searchButton.pinToEdgesSuperview(bottom: 30)
        searchButton.pinToCenterSuperview(centerX: 0)
        searchButton.fixSize(width: 345, height: 58)
        
        textField.pinToCenterSuperview(centerX: 0, centerY: 0)
        textField.pinToEdgesSuperview(leading: 24, trailing: 24)
        textField.fixSize(height: 64)
        
        imageView.pinToCenterSuperview(centerX: 0)
        imageView.fixSize(width: 220, height: 180)
        
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -40),
        ])
        
        searchButton.addAction(.init(handler: { [weak self] _ in
            self?.presentAlert(title: "Test", message: " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", buttonTitle: "ok")
//            self?.output?.didTapSearchButton(username: self?.textField.text ?? "")
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
