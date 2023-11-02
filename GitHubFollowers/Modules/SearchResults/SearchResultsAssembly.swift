//
//  SearchResultsAssembly.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 18.06.23.
//

import UIKit

protocol SearchResultsModuleInput: AnyObject {
    func showFollowers(username: String)
}

enum SearchResultsAssembly {
    static func makeModule(searchedUsername: String) -> UIViewController {
        let viewController = SearchResultsViewController()
        viewController.title = searchedUsername
        let presenter = SearchResultsPresenter(searchedUsername: searchedUsername,
                                               UserNetworkService(ImageLoader.shared))
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
