//
//  FavoritesPresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 08.11.23.
//

import Foundation

protocol FavoritesPresenterOutput: AnyObject {
    func showFavorites(_ followers: [Follower])
}

final class FavoritesPresenter {
    
    struct State {
        var favorites: [Follower]
    }

    weak var view: FavoritesPresenterOutput?
    
    private let storageProvider: StorageProvider
    private var state: State

    init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
        self.state = State(favorites: [])
    }
        
    private func loadFavorites() {
        Task { @MainActor in
            state.favorites = await storageProvider.savedFollowers
            view?.showFavorites(state.favorites)
        }
    }
}

extension FavoritesPresenter: FavoritesViewOutput {
    
    func viewWillAppear() {
        loadFavorites()
    }
    
    func fetchImage(at indexPath: IndexPath) async -> Data? {
        #warning("Need return Image data from cache")
        return nil
    }
}
