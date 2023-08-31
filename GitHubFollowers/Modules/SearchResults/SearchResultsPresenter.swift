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
    func showSearchResults(followers: [User])
    func showProfile(for user: User)
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        var followers: [User]?
    }
    
    weak var view: SearchResultsPresenterOutput?
    
    private let networkService: GFNetworkServiceProtocol
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
    
    init(networkService: GFNetworkServiceProtocol, searchedUsername: String) {
        self.networkService = networkService
        state.searchedUsername = searchedUsername
    }
}

extension SearchResultsPresenter: SearchResultsViewOutput {
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let user = state.followers?[indexPath.row] else { return }
        view?.showProfile(for: user)
    }
    
    func loadImage(for userAvatarUrl: String) async -> Data? {
        do {
            return try await networkService.fetchIcon(for: userAvatarUrl)
        } catch {
            return nil
        }
    }
    
    func viewDidLoad() {
        view?.showLoadingView()
        Task {
            let result = try await networkService.fetchFollowers(for: state.searchedUsername)
            await MainActor.run {
                switch result {
                case .success(let followers):
                    self.state.followers = followers
                    
                case .failure:
                    view?.showErrorMessageView()
                }
                view?.hideLoadingView()
            }
        }
    }
}
