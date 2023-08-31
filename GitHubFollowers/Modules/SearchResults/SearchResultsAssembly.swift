//
//  SearchResultsAssembly.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 18.06.23.
//

import UIKit

enum SearchResultsAssembly {
    static func makeModule(searchedUsername: String) -> UIViewController {
        let viewController = SearchResultsViewController()
        let presenter = SearchResultsPresenter(networkService: GFNetworkMockService(),
                                               searchedUsername: searchedUsername)
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
