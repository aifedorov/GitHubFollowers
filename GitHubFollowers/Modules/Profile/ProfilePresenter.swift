//
//  ProfilePresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 30.08.23.
//

import Foundation
import UIKit

protocol ProfilePresenterOutput: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func setupInitialState(username: String)
    func showUserInfo(_ displayData: ProfileViewController.DisplayData)
    func updateUserAvatar(withImageData imageData: Data)
    func showErrorAlert(title: String, message: String)
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
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter
    }()
    
    private func makeFollowersString(for user: User) -> NSMutableAttributedString {
        let followersString = NSMutableAttributedString(string: "\(user.followers) followers", systemName: "person.2.fill")
        let followingString = NSMutableAttributedString(string: "\(user.following) followers", systemName: "person.2.fill")
        followersString.append(NSAttributedString(string: " "))
        followersString.append(followingString)
        return followersString
    }
    
    private func updateView() {
        guard let user = state.user else { return }
        
        let followersDisplayData = GFBlockView.DisplayData(attributedText: makeFollowersString(for: user),
                                                           buttonTitle: "Show followers",
                                                           buttonAction: {})
        
        let reposString = NSMutableAttributedString(string: "\(user.publicRepos) repos", systemName: "book.pages")
        let reposDisplayData = GFBlockView.DisplayData(attributedText: reposString,
                                                       buttonTitle: "Open profile",
                                                       buttonAction: {})
        let onGitHubSince = "On Github from \(dateFormatter.string(from: user.createdAt))"
        let displayData = ProfileViewController.DisplayData(fullName: user.name ?? "",
                                                            followers: followersDisplayData,
                                                            noFollowers: user.followers == 0,
                                                            repos: reposDisplayData,
                                                            onGitHubSince: onGitHubSince)
        
        view?.showUserInfo(displayData)
    }
    
    private func showErrorAlertView(with alertContent: AlertContent) {
        view?.showErrorAlert(title: alertContent.title, message: alertContent.message)
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        view?.setupInitialState(username: state.follower.login)
        view?.showLoadingView()
        
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
                self.showErrorAlertView(with: .networkError)
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
