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
    private let userNetworkService: UserNetworkServiceProtocol
    private let follower: Follower
    
    init(_ userNetworkService: UserNetworkServiceProtocol, _ follower: Follower) {
        self.follower = follower
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
