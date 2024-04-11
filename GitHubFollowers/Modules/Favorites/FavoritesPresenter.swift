import Foundation
import GFStorage

protocol FavoritesPresenterOutput: AnyObject {
    func showFavorites(_ followers: [Follower])
    func showEmptyView(withTile title: String, message: String, imageType: GFEmptyView.ImageType)
    func hideEmptyView()
    func showErrorAlert(title: String, message: String)
}

final class FavoritesPresenter {
    
    struct State {
        var favorites: [Follower] = []
        var errorContent: FavoritesErrorContent?
    }

    weak var view: FavoritesPresenterOutput?
    
    private let storageProvider: StorageProvider<Follower>
    private var state: State

    init(storageProvider: StorageProvider<Follower>) {
        self.storageProvider = storageProvider
        self.state = State(favorites: [])
    }
    
    private func updateStateView() {
        guard let errorContent = state.errorContent else {
            view?.hideEmptyView()
            return
        }
        switch errorContent {
        case .unknownError:
            view?.showErrorAlert(title: errorContent.title, message: errorContent.message)
        case .noFavorites:
            view?.showEmptyView(withTile: errorContent.title, message: errorContent.message, imageType: .noFollowers)
        }
    }
        
    private func loadFavorites() {
        state.errorContent = nil
        updateStateView()
        
        Task { @MainActor in
            do {
                state.favorites = try await storageProvider.load()
                view?.showFavorites(state.favorites)
                
                if state.favorites.isEmpty {
                    state.errorContent = .noFavorites
                }
            } catch {
                state.errorContent = .unknownError
            }
            updateStateView()
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
