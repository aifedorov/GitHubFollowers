//
//  GFNavigationViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 17.05.23.
//

import UIKit

class GFNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brand
        
        navigationBar.backgroundColor = .brand
        navigationBar.scrollEdgeAppearance = appearance
    }
}
