//
//  SceneDelegate.swift
//  GithubFollowers
//
//  Created by Aleksandr Fedorov on 09.05.23.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        setupAppearance()
        
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
    }
    
    private func makeRootViewController() -> UIViewController {
        let rootViewController = UITabBarController()
        let searchViewController = SearchAssembly.makeModule()
        let favoritesViewController = FavoritesViewController()
        
        searchViewController.tabBarItem = UITabBarItem(title: "Followers",
                                                       image: UIImage(systemName: "person.3"),
                                                       selectedImage: UIImage(systemName: "person.3.fill"))
        
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites",
                                                          image: UIImage(systemName: "star"),
                                                          selectedImage: UIImage(systemName: "star.fill"))
        
        rootViewController.viewControllers = [GFNavigationViewController(rootViewController: searchViewController),
                                              GFNavigationViewController(rootViewController: favoritesViewController)]
        rootViewController.selectedIndex = 0
        return rootViewController
    }
    
    private func setupAppearance() {
        UITabBar.appearance().backgroundColor = .brand
        UITabBar.appearance().barTintColor = .brand
    }
}
