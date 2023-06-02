//
//  SearchAssembly.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 24.05.23.
//

import UIKit

enum SearchAssembly {
    static func makeModule() -> UIViewController {
        let viewController = SearchViewController()
        let presenter = SearchPresenter(networkService: NetworkService())
        let router = SearchRouter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.router = router
        
        router.transitionHandler = viewController
        
        return viewController
    }
}
