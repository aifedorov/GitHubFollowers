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
    func showSearchResults(followers: [Follower])
    func showProfile(for follower: Follower)
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        var followers: [Follower]?
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
                view?.showSearchResults(followers: followers)
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
        guard let user = state.followers?[indexPath.row] else { return }
        view?.showProfile(for: user)
    }
    
    func loadImage(for userAvatarUrl: String) async -> Data? {
        do {
            return try await userNetworkService.fetchAvatarImage(fromURL: userAvatarUrl)
        } catch {
            // TODO: Show alert
            return nil
        }
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
