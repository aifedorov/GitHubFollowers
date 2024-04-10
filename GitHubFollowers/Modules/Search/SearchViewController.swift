import UIKit

protocol SearchViewOutput {
    func didTapSearchButton(username: String)
}

final class SearchViewController: UIViewController {
    
    var output: SearchViewOutput?
    
    private lazy var searchButton: GFButton = {
        GFButton(title: "Get Followers", controlSize: .big)
    }()
    private lazy var textField: GFUsernameTextField = {
        let textField = GFUsernameTextField(placeholder: "Enter username")
        textField.delegate = self
        return textField
    }()
    private lazy var imageView: UIImageView = {
        let image = UIImage.mainLogo
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
