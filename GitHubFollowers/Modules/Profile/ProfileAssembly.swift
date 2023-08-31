//
//  ProfileAssembly.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 30.08.23.
//

import UIKit

enum ProfileAssembly {
    static func makeModule(with user: User) -> UIViewController {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(user)
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
