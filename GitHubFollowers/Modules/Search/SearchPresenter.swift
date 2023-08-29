//
//  SearchPresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 27.05.23.
//

import Foundation

protocol SearchPresenterOutput: AnyObject {
    func showSearchResults(searchedUsername: String)
}

final class SearchPresenter {
    
    struct State {
        var inputUserName: String = ""
    }
    
    weak var view: SearchPresenterOutput?
    
    private let networkService: GFNetworkService
    private var state = State()
    
    init(networkService: GFNetworkService) {
        self.networkService = networkService
    }
}

extension SearchPresenter: SearchViewOutput {
        
    func didTapSearchButton(username: String) {
        state.inputUserName = username
        view?.showSearchResults(searchedUsername: state.inputUserName)
    }
}
