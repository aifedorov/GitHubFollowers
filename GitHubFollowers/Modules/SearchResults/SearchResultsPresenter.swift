//
//  SearchResultsPresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 18.06.23.
//

import Foundation

protocol SearchResultsPresenterOutput: AnyObject {
    
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
        // TODO: Show loding and request followers
    }
}
