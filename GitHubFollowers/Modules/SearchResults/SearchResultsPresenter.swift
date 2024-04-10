import Foundation
import GFNetwork

protocol SearchResultsPresenterOutput: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showFullScreenErrorMessageView(withTile title: String, message: String)
    func hideFullScreenErrorMessageView()
    func showFollowers(_ followers: [Follower])
    func updateTitle(username: String)
    func showProfile(for follower: Follower, searchResultsModuleInput: SearchResultsModuleInput)
    func closeProfile(completion: @escaping () -> Void)
    func showSuccessAlert(title: String, message: String)
    func showErrorAlert(title: String, message: String)
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        var errorContent: ErrorContent?
        
        private var followers: [Follower] = []
        private var filteredFollowers: [Follower] = []
        private(set) var isSearching = false
        
        func getFollower(at index: Int) -> Follower {
            let followers = getAllFollowers()
            return followers[index]
        }
        
        func getAllFollowers() -> [Follower] {
            guard !isSearching else {
                return filteredFollowers
            }
            return followers
        }
        
        mutating func updateFollowers(_ followers: [Follower]) {
            self.followers = followers
        }
        
        mutating func updateSearchResult(for query: String) {
            isSearching = !query.isEmpty
            guard isSearching else { return }
            let filter = query.lowercased()
            filteredFollowers = followers.filter { $0.login.lowercased().contains(filter) }
        }
    }
    
    weak var view: SearchResultsPresenterOutput?
    
    private let userNetworkService: UserNetworkServiceProtocol
    private var state = State()
    
    init(searchedUsername: String, _ userNetworkService: UserNetworkServiceProtocol) {
        self.state.searchedUsername = searchedUsername
        self.userNetworkService = userNetworkService
    }
    
    private func showError() {
        guard let errorContent = state.errorContent else { return }
        let activeFollowers = state.getAllFollowers()
        if activeFollowers.isEmpty {
            view?.showFullScreenErrorMessageView(withTile: errorContent.title, message: errorContent.message)
        } else {
            view?.showErrorAlert(title: errorContent.title, message: errorContent.message)
        }
    }
    
    private func showFollowers() {
        view?.showFollowers(state.getAllFollowers())
    }
    
    private func fetchFollowers(username: String) {
        view?.showLoadingView()
        view?.hideFullScreenErrorMessageView()
        
        Task { @MainActor in
            do {
                let followers = try await userNetworkService.fetchFollowers(for: state.searchedUsername)
                state.updateFollowers(followers)
                showFollowers()
            } catch NetworkError.resourceNotFound {
                state.errorContent = .userNotFound
                showError()
            } catch {
                state.errorContent = .networkError
                showError()
            }
            
            view?.hideLoadingView()
        }
    }
}

extension SearchResultsPresenter: SearchResultsViewOutput {
    
    func didSelectItem(at indexPath: IndexPath) {
        let follower = state.getFollower(at: indexPath.row)
        view?.showProfile(for: follower, searchResultsModuleInput: self)
    }
    
    func fetchImage(at indexPath: IndexPath) async -> Data? {
        let follower = state.getFollower(at: indexPath.row)
        // Ignore this error because it doesn't matter to a user.
        return try? await userNetworkService.fetchAvatarImage(fromURL: follower.avatarUrl)
    }
    
    func viewDidLoad() {
        view?.updateTitle(username: state.searchedUsername)
        fetchFollowers(username: state.searchedUsername)
    }
    
    func searchQueryDidChange(query: String) {
        state.updateSearchResult(for: query)
        showFollowers()
    }
}

extension SearchResultsPresenter: SearchResultsModuleInput {
    
    func showFollowers(username: String) {
        state.searchedUsername = username
        
        view?.updateTitle(username: state.searchedUsername)
        view?.closeProfile { [weak self] in
            guard let self else { return }
            self.fetchFollowers(username: username)
        }
    }
}
