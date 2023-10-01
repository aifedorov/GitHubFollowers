//
//  SearchResultsPresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 18.06.23.
//

import Foundation

enum CGSearchResultError {
    case userNotFound
    case userHaveNoFollowers
    case networkError
}

protocol SearchResultsPresenterOutput: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showFullScreenErrorMessageView(with message: String)
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
        private var isFiltering = false
        
        func getFollower(at index: Int) -> Follower {
            let followers = getAllFollowers()
            return followers[index]
        }
        
        func getAllFollowers() -> [Follower] {
            guard !isFiltering else {
                return filteredFollowers
            }
            return followers
        }
        
        mutating func updateFollowers(_ followers: [Follower]) {
            self.followers = followers
        }
                
        mutating func updateSearchResult(for query: String) {
            isFiltering = !query.isEmpty
            guard isFiltering else {
                filteredFollowers = []
                return
            }
            let filter = query.lowercased()
            filteredFollowers = followers.filter { $0.login.lowercased().contains(filter) }
        }
    }
    
    weak var view: SearchResultsPresenterOutput?
    
    private let userNetworkService: UserNetworkServiceProtocol
    private var state = State() {
        didSet {
            view?.hideFullScreenErrorMessageView()
            
            let followers = state.getAllFollowers()
            if followers.isEmpty {
                view?.showFullScreenErrorMessageView(with: makeErrorMessage(.userHaveNoFollowers))
            } else {
                view?.showFollowers(followers)
            }
        }
    }
    
    init(searchedUsername: String, _ userNetworkService: UserNetworkServiceProtocol) {
        self.state.searchedUsername = searchedUsername
        self.userNetworkService = userNetworkService
    }
    
    private func makeErrorMessage(_ error: CGSearchResultError) -> String {
        switch error {
        case .userNotFound:
            return "User not found."
        case .userHaveNoFollowers:
            return "This user doesn’t have any followers."
        case .networkError:
            return "Network error. Please check the internet connection and try again."
        }
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
        Task { @MainActor in
            do {
                let followers = try await userNetworkService.fetchFollowers(for: state.searchedUsername)
                self.state.updateFollowers(followers)
            } catch NetworkError.resourceNotFound {
                view?.showFullScreenErrorMessageView(with: makeErrorMessage(.userNotFound))
            } catch {
                view?.showFullScreenErrorMessageView(with: makeErrorMessage(.networkError))
            }
            view?.hideLoadingView()
        }
    }
    
    func searchQueryDidChange(query: String) {
        state.updateSearchResult(for: query)
    }
}
