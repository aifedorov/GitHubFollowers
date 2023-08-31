//
//  ProfilePresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 30.08.23.
//

import Foundation

protocol ProfilePresenterOutput: AnyObject {}

final class ProfilePresenter {
    
    weak var view: ProfilePresenterOutput?
    private let user: User
    
    init(_ user: User) {
        self.user = user
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        // TODO: Configure screen with User model
    }
    
    func didTapOpenProfileButton() {
        // TODO: Open profile URL
    }
    
    func didTapAddToFavoriteButton() {
        // TODO: Add to favorite
    }
}
