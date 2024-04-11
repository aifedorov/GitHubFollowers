import Foundation
import GFNetwork

protocol SearchResultsPresenterOutput: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withTile title: String, message: String, imageType: GFEmptyView.ImageType)
    func hideEmptyView()
    func showFollowers(_ followers: [Follower])
    func updateTitle(username: String)
    func showProfile(for follower: Follower, searchResultsModuleInput: SearchResultsModuleInput)
    func closeProfile(completion: @escaping () -> Void)
    func showErrorAlert(title: String, message: String)
}

final class SearchResultsPresenter {
    
    struct State {
        var searchedUsername: String = ""
        var errorContent: SearchResultErrorContent?
        
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
    
    private func updateErrorView() {
        guard let errorContent = state.errorContent else {
            view?.hideEmptyView()
            return
        }
        switch errorContent {
        case .networkError:
            view?.showErrorAlert(title: errorContent.title, message: errorContent.message)
        case .userHaveNoFollowers:
            view?.showEmptyView(withTile: errorContent.title, message: errorContent.message, imageType: .noFollowers)
        case .userNotFound:
            view?.showEmptyView(withTile: errorContent.title, message: errorContent.message, imageType: .userNotFound)
        }
    }
    
    private func updateFollowers() {
        view?.showFollowers(state.getAllFollowers())
    }
    
    private func fetchFollowers(username: String) {
        view?.showLoadingView()
        state.errorContent = nil
        updateErrorView()
        
        Task { @MainActor in
            do {
                let followers = try await userNetworkService.fetchFollowers(for: state.searchedUsername)
                state.updateFollowers(followers)
                if followers.isEmpty {
                    state.errorContent = .userHaveNoFollowers
                }
            } catch NetworkError.resourceNotFound {
                state.errorContent = .userNotFound
            } catch {
                state.errorContent = .networkError
            }
            
            updateFollowers()
            updateErrorView()
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
        updateFollowers()
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
