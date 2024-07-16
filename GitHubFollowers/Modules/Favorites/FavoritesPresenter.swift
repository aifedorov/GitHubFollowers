import Foundation
import GFStorage
import GFCommon

protocol FavoritesPresenterOutput: AnyObject {
    func showFavorites(_ followers: [Follower])
    func showEmptyView(withTile title: String, message: String, imageType: GFEmptyView.ImageType)
    func hideEmptyView()
    func showErrorAlert(title: String, message: String)
    func showProfile(for follower: Follower, profileModuleOutput: ProfileModuleOutput)
    func closeProfile(completion: @escaping () -> Void)
    func showFollowers(username: String)
}

final class FavoritesPresenter {
    
    struct State {
        var favorites: [Follower] = []
        var errorContent: FavoritesErrorContent?
    }

    weak var view: FavoritesPresenterOutput?
    
    private let favoritesStorageProvider: FavoritesStorageProvider
    private let userNetworkService: UserNetworkServiceProtocol
    private var state: State

    init(_ favoritesStorageProvider: FavoritesStorageProvider, _ userNetworkService: UserNetworkServiceProtocol) {
        self.favoritesStorageProvider = favoritesStorageProvider
        self.userNetworkService = userNetworkService
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
            view?.showEmptyView(withTile: errorContent.title, message: errorContent.message, imageType: .noFavorites)
        @unknown default:
            view?.showErrorAlert(title: errorContent.title, message: errorContent.message)
        }
    }
        
    private func loadFavorites() {
        state.errorContent = nil
        updateStateView()
        
        Task { @MainActor in
            do {
                state.favorites = try await favoritesStorageProvider.storageProvider.load()
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
        let follower = state.favorites[indexPath.row]
        return try? await userNetworkService.fetchAvatarImage(fromURL: follower.avatarUrl)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let follower = state.favorites[indexPath.row]
        view?.showProfile(for: follower, profileModuleOutput: self)
    }
}

extension FavoritesPresenter: ProfileModuleOutput {
    
    func profileWantsToClose() {
        view?.closeProfile { [weak self] in
            self?.loadFavorites()
        }
    }
    
    func showFollowers(username: String) {
        view?.showFollowers(username: username)
    }
}
