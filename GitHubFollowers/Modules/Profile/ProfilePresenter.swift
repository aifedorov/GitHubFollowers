//
//  ProfilePresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 30.08.23.
//

import Foundation

protocol ProfilePresenterOutput: AnyObject {
    func showLoadingView()
    func hideLoadingView()
}

final class ProfilePresenter {
    
    weak var view: ProfilePresenterOutput?
    private let userNetworkService: GFUserNetworkServiceProtocol
    private let user: User
    
    init(_ userNetworkService: GFUserNetworkServiceProtocol, _ user: User) {
        self.user = user
        self.userNetworkService = userNetworkService
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        // TODO: Update profile screen with real data
    }
    
    func didTapOpenProfileButton() {
        // TODO: Open profile URL
    }
    
    func didTapAddToFavoriteButton() {
        // TODO: Add to favorite
    }
}
