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
    func showErrorMessageView(with text: String)
    func showEmptyView()
    func showSearchResults(followers: [User])
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        var followers: [User]?
    }
    
    weak var view: SearchResultsPresenterOutput?
    
    private let networkService: NetworkService
    private var state = State() {
        didSet {
            guard let followers = state.followers else {
                // TODO: Show fullscreen error
                return
            }
            
            if followers.isEmpty {
                view?.showEmptyView()
            } else {
                view?.showSearchResults(followers: followers)
            }
        }
    }
    
    init(networkService: NetworkService, searchedUsername: String) {
        self.networkService = networkService
        state.searchedUsername = searchedUsername
    }
}

extension SearchResultsPresenter: SearchResultsViewOutput {
    
    func viewDidLoad() {
        view?.showLoadingView()
        Task {
            let result = try await networkService.fetchFollowers(for: state.searchedUsername)
            await MainActor.run {
                switch result {
                case .success(let followers):
                    debugPrint(followers)
                    self.state.followers = followers
                    
                case .failure(let error):
                    debugPrint("Something wrong \(error.localizedDescription)")
                    view?.showErrorMessageView(with: "Something wrong")
                }
                
                view?.hideLoadingView()
            }
        }
    }
}
