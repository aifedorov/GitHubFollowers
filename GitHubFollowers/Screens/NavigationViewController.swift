//
//  NavigationViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 17.05.23.
//

import UIKit

final class NavigationViewController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandColor
        
        navigationBar.backgroundColor = .brandColor
        navigationBar.scrollEdgeAppearance = appearance
    }
}
