//
//  SearchResultsPresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 18.06.23.
//

import Foundation

protocol SearchResultsPresenterOutput: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showErrorMessageView()
    func hideErrorMessageView()
    func showEmptyView()
    func hideEmptyView()
    func showSearchResults(_ followers: [Follower])
    func showProfile(for follower: Follower)
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        var followers: [Follower]?
        
        func getFollower(at index: Int) -> Follower? {
            guard let followers = followers else { return nil }
            return followers[index]
        }
    }
    
    weak var view: SearchResultsPresenterOutput?
    
    private let userNetworkService: GFUserNetworkServiceProtocol
    
    private var state = State() {
        didSet {
            guard let followers = state.followers else {
                self.view?.showErrorMessageView()
                return
            }
            self.view?.hideErrorMessageView()
            
            if followers.isEmpty {
                view?.showEmptyView()
            } else {
                view?.hideEmptyView()
                view?.showSearchResults(followers)
            }
        }
    }
    
    init(searchedUsername: String, _ userNetworkService: GFUserNetworkServiceProtocol) {
        self.state.searchedUsername = searchedUsername
        self.userNetworkService = userNetworkService
    }
}

extension SearchResultsPresenter: SearchResultsViewOutput {
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let follower = state.getFollower(at: indexPath.row) else { return }
        view?.showProfile(for: follower)
    }
    
    func fetchImage(at indexPath: IndexPath) async -> Data? {
        guard let follower = state.getFollower(at: indexPath.row) else { return nil }
        // Ignore this error because it doesn't matter to a user.
        return try? await userNetworkService.fetchAvatarImage(fromURL: follower.avatarUrl)
    }
    
    func viewDidLoad() {
        view?.showLoadingView()
        Task { @MainActor in
            do {
                let followers = try await userNetworkService.fetchFollowers(for: state.searchedUsername)
                self.state.followers = followers
            } catch {
                view?.showErrorMessageView()
            }
            view?.hideLoadingView()
        }
    }
}
