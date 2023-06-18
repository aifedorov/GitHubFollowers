//
//  SearchPresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 27.05.23.
//

import Foundation

struct SearchPresenterState {
    var inputUserName: String = ""
    var followers: [User]?
}

protocol SearchPresenterOutput: AnyObject {
    func showSearchResults()
}

final class SearchPresenter {
    
    weak var view: SearchPresenterOutput?
    
    private let networkService: NetworkService
    private var state = SearchPresenterState()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension SearchPresenter: SearchViewOutput {
        
    func didTapSearchButton(username: String) {
        self.state.inputUserName = username
    }
}
