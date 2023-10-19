//
//  SceneDelegate.swift
//  GithubFollowers
//
//  Created by Aleksandr Fedorov on 09.05.23.
//

import UIKit
import TinyDI

enum DependanciesNames {
    enum Module {
        static let search = "SearchModule"
        static let searchResults = "SearchResultsModule"
        static let favorites = "FavoritesModule"
    }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let container = DIContainer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        setupAppearance()
        registerDependancies()
        
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
    }
    
    private func makeRootViewController() -> UIViewController {
        let rootViewController = UITabBarController()
        let searchViewController = container.resolve(UIViewController.self, name: DependanciesNames.Module.search)!
        let favoritesViewController = container.resolve(UIViewController.self, name: DependanciesNames.Module.favorites)!
        
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
    
    private func registerDependancies() {
        container.register(UIViewController.self, name: DependanciesNames.Module.search, factory: SearchAssembly.makeModule)
        container.register(UIViewController.self, name: DependanciesNames.Module.searchResults) { (searchedUsername: String) in
            SearchResultsAssembly.makeModule(searchedUsername: searchedUsername)
        }
        container.register(UIViewController.self, name: DependanciesNames.Module.favorites) {
            FavoritesViewController()
        }
    }
    
    private func setupAppearance() {
        UITabBar.appearance().backgroundColor = .brand
        UITabBar.appearance().barTintColor = .brand
    }
}
