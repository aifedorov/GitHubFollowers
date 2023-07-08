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
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        var followers: [User]?
    }
    
    weak var view: SearchResultsPresenterOutput?
    
    private let networkService: NetworkService
    private var state = State()
    
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
            switch result {
            case .success(let users):
                self.state.followers = users
                debugPrint(users)
                
            case .failure(let error): break
                // TODO: Show alert with error
            }
            
            await MainActor.run {
                view?.hideLoadingView()
            }
        }
    }
}
