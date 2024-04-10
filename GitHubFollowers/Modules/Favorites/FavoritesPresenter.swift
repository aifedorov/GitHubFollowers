import Foundation
import GFStorage

protocol FavoritesPresenterOutput: AnyObject {
    func showFavorites(_ followers: [Follower])
}

final class FavoritesPresenter {
    
    struct State {
        var favorites: [Follower]
    }

    weak var view: FavoritesPresenterOutput?
    
    private let storageProvider: StorageProvider<Follower>
    private var state: State

    init(storageProvider: StorageProvider<Follower>) {
        self.storageProvider = storageProvider
        self.state = State(favorites: [])
    }
        
    private func loadFavorites() {
        Task { @MainActor in
            state.favorites = try await storageProvider.load()
            view?.showFavorites(state.favorites)
        }
    }
}

extension FavoritesPresenter: FavoritesViewOutput {
    
    func viewWillAppear() {
        loadFavorites()
    }
    
    func fetchImage(at indexPath: IndexPath) async -> Data? {
        return nil
    }
}
