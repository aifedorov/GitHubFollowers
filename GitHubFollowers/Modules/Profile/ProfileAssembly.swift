//
//  ProfileAssembly.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 30.08.23.
//

import UIKit

enum ProfileAssembly {
    static func makeModule(with follower: Follower) -> UIViewController {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(UserNetworkService(ImageLoader.shared), follower)
        
        viewController.output = presenter
        presenter.view = viewController
        
        return GFNavigationViewController(rootViewController: viewController)
    }
}
