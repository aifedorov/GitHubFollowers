//
//  SearchResultsViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 16.05.23.
//

import UIKit

protocol SearchResultsViewOutput {
    func viewDidLoad()
}

final class SearchResultsViewController: UIViewController {
    
    var output: SearchResultsViewOutput?
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        loadingView.color = .accentColor
        return loadingView
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView(with: "This user doesn’t exits or doesn’t have any followers",
                                  buttonAction: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
        
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        output?.viewDidLoad()
    }
}

extension SearchResultsViewController: SearchResultsPresenterOutput {
        
    func showErrorMessageView(with text: String) {
        emptyStateView.removeFromSuperview()
    }
    
    func showEmptyView() {
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func showLoadingView() {
        emptyStateView.removeFromSuperview()
        loadingView.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.stopAnimating()
    }
}
