//
//  SearchResultsAssembly.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 18.06.23.
//

import UIKit

enum SearchResultsAssembly {
    static func makeModule() -> UIViewController {
        let viewController = SearchResultsViewController()
        let presenter = SearchResultsPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
