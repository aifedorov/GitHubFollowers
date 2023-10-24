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
    func showFullScreenErrorMessageView(withTile title: String, message: String)
    func hideFullScreenErrorMessageView()
    func showFollowers(_ followers: [Follower])
    func showProfile(for follower: Follower)
    func showSuccessAlert(title: String, message: String)
    func showErrorAlert(title: String, message: String)
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        
        private var followers: [Follower] = []
        private var filteredFollowers: [Follower] = []
        private(set) var isSearching = false
        
        func getFollower(at index: Int) -> Follower {
            let followers = getAllFollowers()
            return followers[index]
        }
        
        func getAllFollowers() -> [Follower] {
            guard !isSearching else {
                return filteredFollowers
            }
            return followers
        }
        
        mutating func updateFollowers(_ followers: [Follower]) {
            self.followers = followers
        }
                
        mutating func updateSearchResult(for query: String) {
            isSearching = !query.isEmpty
            guard isSearching else { return }
            let filter = query.lowercased()
            filteredFollowers = followers.filter { $0.login.lowercased().contains(filter) }
        }
    }
    
    weak var view: SearchResultsPresenterOutput?
    
    private let userNetworkService: UserNetworkServiceProtocol
    private var state = State() {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        view?.hideFullScreenErrorMessageView()
        
        let followers = state.getAllFollowers()
        if followers.isEmpty && !state.isSearching {
            showFullScreenErrorMessageView(with: .userHaveNoFollowers)
        } else {
            view?.showFollowers(followers)
        }
    }
    
    init(searchedUsername: String, _ userNetworkService: UserNetworkServiceProtocol) {
        self.state.searchedUsername = searchedUsername
        self.userNetworkService = userNetworkService
    }
    
    private func showFullScreenErrorMessageView(with alertContent: AlertContent) {
        view?.showFullScreenErrorMessageView(withTile: alertContent.title, message: alertContent.message)
    }
}

extension SearchResultsPresenter: SearchResultsViewOutput {
    
    func didSelectItem(at indexPath: IndexPath) {
        let follower = state.getFollower(at: indexPath.row)
        view?.showProfile(for: follower)
    }
    
    func fetchImage(at indexPath: IndexPath) async -> Data? {
        let follower = state.getFollower(at: indexPath.row)
        // Ignore this error because it doesn't matter to a user.
        return try? await userNetworkService.fetchAvatarImage(fromURL: follower.avatarUrl)
    }
    
    func viewDidLoad() {
        view?.showLoadingView()
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let followers = try await self.userNetworkService.fetchFollowers(for: self.state.searchedUsername)
                self.state.updateFollowers(followers)
            } catch NetworkError.resourceNotFound {
                self.showFullScreenErrorMessageView(with: .userNotFound)
            } catch {
                self.showFullScreenErrorMessageView(with: .networkError)
            }
            self.view?.hideLoadingView()
        }
    }
    
    func searchQueryDidChange(query: String) {
        state.updateSearchResult(for: query)
    }
}
