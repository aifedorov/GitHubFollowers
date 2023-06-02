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

protocol SearchPresenterOutput {
    func viewDidLoad()
    func didTapSearchButton(username: String)
}

final class SearchPresenter {
    // TODO: Make service for this module certainly. Use specific protocol or class.
    private let networkService: NetworkService
    
    weak var view: SearchViewController?
    var router: SearchRouter?
    
    private var state = SearchPresenterState()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension SearchPresenter: SearchPresenterOutput {
    
    func viewDidLoad() {

    }
    
    func didTapSearchButton(username: String) {
        self.state.inputUserName = username
        
        Task {
            let result = try await self.networkService.fetchFollowers(for: self.state.inputUserName)
            
            switch result {
            case .success(let users):
                self.state.followers =  users
            case .failure: break
                // TODO: show alert
            }
            
            debugPrint(self.state.followers ?? [])
        }
    }
}
