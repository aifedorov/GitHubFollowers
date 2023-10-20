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
    func showPlaceholderViewWith(username: String)
    func updateUserAvatar(withImageData imageData: Data)
    func showUserInfo(_ displayData: ProfileViewController.DisplayData)
}

final class ProfilePresenter {
    
    struct State {
        var follower: Follower
        var user: User?
    }
    
    weak var view: ProfilePresenterOutput?
    private let userNetworkService: UserNetworkServiceProtocol
    
    private var state: State {
        didSet {
            updateView()
        }
    }
    
    init(_ userNetworkService: UserNetworkServiceProtocol, _ follower: Follower) {
        self.state = State(follower: follower)
        self.userNetworkService = userNetworkService
    }
    
    private func updateView() {
        if let user = state.user {
            let displayData = ProfileViewController.DisplayData(fullName: user.name,
                                                                username: user.login,
                                                                bio: user.bio ?? "")
            view?.showUserInfo(displayData)
        }
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        view?.showLoadingView()
        view?.showPlaceholderViewWith(username: state.follower.login)
        
        Task { @MainActor [weak self] in
            guard let self, let data = try? await self.userNetworkService.fetchAvatarImage(fromURL: self.state.follower.avatarUrl) else { return }
            self.view?.updateUserAvatar(withImageData: data)
        }
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let user = try await self.userNetworkService.fetchUserInfo(for: self.state.follower.login)
                self.state.user = user
            } catch {
                debugPrint(error.localizedDescription)
                // TODO: Show alert
            }
            view?.hideLoadingView()
        }
    }
    
    func didTapOpenProfileButton() {
        // TODO: Open profile URL
    }
    
    func didTapAddToFavoriteButton() {
        // TODO: Add to favorite
    }
}
