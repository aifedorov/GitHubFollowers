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
    func showSafari(with url: URL)
}

final class ProfilePresenter {
    
    struct State {
        var follower: Follower
        var user: User?
    }
    
    weak var view: ProfilePresenterOutput?
    weak var searchResultsModuleInput: SearchResultsModuleInput?
    
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
                                                           buttonTitle: "Show followers")
        
        let reposString = NSMutableAttributedString(string: "\(user.publicRepos) repos", systemName: "book.pages")
        let reposDisplayData = GFBlockView.DisplayData(attributedText: reposString,
                                                       buttonTitle: "Open profile")
        let onGitHubSince = "On Github from \(dateFormatter.string(from: user.createdAt))"
        let displayData = ProfileViewController.DisplayData(fullName: user.name ?? "",
                                                            username: user.login,
                                                            followers: followersDisplayData,
                                                            noFollowers: user.followers == 0,
                                                            repos: reposDisplayData,
                                                            onGitHubSince: onGitHubSince)
        
        view?.showUserInfo(displayData)
    }
    
    private func showErrorAlertView(with alertContent: ErrorContent) {
        view?.showErrorAlert(title: alertContent.title, message: alertContent.message)
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        view?.setupInitialState(username: state.follower.login)
        view?.showLoadingView()
        
        Task { @MainActor in
            guard let data = try? await userNetworkService.fetchAvatarImage(fromURL: state.follower.avatarUrl) else { return }
            view?.updateUserAvatar(withImageData: data)
        }
        
        Task { @MainActor in
            do {
                let user = try await userNetworkService.fetchUserInfo(for: state.follower.login)
                state.user = user
            } catch {
                showErrorAlertView(with: .networkError)
            }
            
            view?.hideLoadingView()
        }
    }
    
    func didTapAddToFavoriteButton() {
        // TODO: Add to favorite
    }
    
    func didTapShowFollowersButton() {
        guard let user = state.user else { return }
        searchResultsModuleInput?.showFollowers(username: user.login)
    }
    
    func didTapOpenProfileButton() {
        guard let user = state.user, let url = URL(string: user.htmlUrl) else {
            view?.showErrorAlert(title: "Invalid URL", message: "The url attached to this user is invalid.")
            return
        }
        
        view?.showSafari(with: url)
    }
}
