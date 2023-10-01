//
//  FavoritesViewController.swift
//  GithubFollowers
//
//  Created by Aleksandr Fedorov on 11.05.23.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private lazy var favoritesIsEmptyImageView: UIImageView = {
        let image = UIImage.favoritesEmpty
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubviews([favoritesIsEmptyImageView])
        
        favoritesIsEmptyImageView.pinToEdgesSuperview(top: 206)
        favoritesIsEmptyImageView.pinToCenterSuperview(centerX: 0)
        favoritesIsEmptyImageView.fixSize(width: 208, height: 232)
    }
}
