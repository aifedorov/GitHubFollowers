//
//  FavoritesAssembly.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 08.11.23.
//

import UIKit

enum FavoritesAssembly {
    static func makeModule() -> UIViewController {
        let viewController = FavoritesViewController()
        let presenter = FavoritesPresenter(storageProvider: StorageProvider.shared)
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
