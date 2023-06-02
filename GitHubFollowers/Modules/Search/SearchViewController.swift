//
//  SearchViewController.swift
//  GithubFollowers
//
//  Created by Aleksandr Fedorov on 09.05.23.
//

import UIKit

final class SearchViewController: UIViewController {
    
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
        
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.autocapitalizationType = .none
        
        textField.delegate = self
        return textField
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "title-image")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var output: SearchPresenterOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        output?.viewDidLoad()
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
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        searchButton.addAction(.init(handler: { [weak self] _ in
            self?.output?.didTapSearchButton(username: self?.textField.text ?? "")
        }), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        updateStateSearchButton(nil)
    }
    
    @objc private func didTapOnView(_ sender: UIView) {
        textField.resignFirstResponder()
    }
    
    private func showSearchResult() {
        let searchViewController = SearchResultsViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    private func updateStateSearchButton(_ text: String?) {
        guard let text = text else {
            searchButton.isEnabled = false
            return
        }
        
        searchButton.isEnabled = !text.isEmpty
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateStateSearchButton(textField.text)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        updateStateSearchButton(textField.text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
