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
        let presenter = SearchPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
