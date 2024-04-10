import UIKit
import GFStorage

protocol ProfilePresenterOutput: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func setupInitialState(username: String)
    func showUserInfo(_ displayData: ProfileViewController.DisplayData)
    func updateUserAvatar(withImageData imageData: Data)
    func showErrorAlert(title: String, message: String)
    func showSafari(with url: URL)
    func updateFavoriteButton(isHighlighted: Bool)
    func updateFavoriteButton(isEnabled: Bool)
}

final class ProfilePresenter {
    
    struct State {
        var follower: Follower
        var user: User?
        var isFavoriteButtonHighlighted = false
    }
    
    weak var view: ProfilePresenterOutput?
    weak var searchResultsModuleInput: SearchResultsModuleInput?
    
    private let userNetworkService: UserNetworkServiceProtocol
    private let storageProvider: StorageProvider<Follower>
    
    private var state: State {
        didSet {
            updateView()
        }
    }
    
    init(_ userNetworkService: UserNetworkServiceProtocol, storageProvider: StorageProvider<Follower>, _ follower: Follower) {
        self.userNetworkService = userNetworkService
        self.storageProvider = storageProvider
        self.state = State(follower: follower)
        
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        view?.updateFavoriteButton(isEnabled: false)
        Task { @MainActor in
            state.isFavoriteButtonHighlighted = await storageProvider.contains(state.follower)
            view?.updateFavoriteButton(isHighlighted: state.isFavoriteButtonHighlighted)
            view?.updateFavoriteButton(isEnabled: true)
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter
    }()
    
    private func makeFollowersString(for user: User) -> NSMutableAttributedString {
        let followersString = NSMutableAttributedString(string: "\(user.followers) followers", systemName: "person.2.fill")
        let followingString = NSMutableAttributedString(string: "\(user.following) followers", systemName: "person.2.fill")
        followersString.append(NSAttributedString(string: " "))
        followersString.append(followingString)
        return followersString
    }
    
    private func updateView() {
        guard let user = state.user else { return }
        
        let followersDisplayData = GFBlockView.DisplayData(attributedText: makeFollowersString(for: user),
                                                           buttonTitle: "Show followers")
        
        let reposString = NSMutableAttributedString(string: "\(user.publicRepos) repos", systemName: "book.pages")
        let reposDisplayData = GFBlockView.DisplayData(attributedText: reposString,
                                                       buttonTitle: "Open profile")
        let onGitHubSince = "On Github from \(dateFormatter.string(from: user.createdAt))"
        let displayData = ProfileViewController.DisplayData(fullName: user.name ?? "",
                                                            username: user.login,
                                                            followers: followersDisplayData,
                                                            noFollowers: user.followers == 0,
                                                            repos: reposDisplayData,
                                                            onGitHubSince: onGitHubSince)
        
        view?.showUserInfo(displayData)
        updateFavoriteButton()
    }
    
    private func showErrorAlertView(with alertContent: ErrorContent) {
        view?.showErrorAlert(title: alertContent.title, message: alertContent.message)
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        view?.setupInitialState(username: state.follower.login)
        view?.showLoadingView()
        
        Task { @MainActor in
            guard let data = try? await userNetworkService.fetchAvatarImage(fromURL: state.follower.avatarUrl) else { return }
            view?.updateUserAvatar(withImageData: data)
        }
        
        Task { @MainActor in
            do {
                let user = try await userNetworkService.fetchUserInfo(for: state.follower.login)
                state.user = user
            } catch {
                showErrorAlertView(with: .networkError)
            }
            
            view?.hideLoadingView()
        }
    }
    
    func didTapAddToFavoriteButton() {
        Task { @MainActor in
            let follower = state.follower
            if await !storageProvider.contains(follower) {
                try await storageProvider.save([follower])
            } else {
                try await storageProvider.delete([follower])
            }
            
            updateFavoriteButton()
        }
    }
    
    func didTapShowFollowersButton() {
        guard let user = state.user else { return }
        searchResultsModuleInput?.showFollowers(username: user.login)
    }
    
    func didTapOpenProfileButton() {
        guard let user = state.user, let url = URL(string: user.htmlUrl) else {
            view?.showErrorAlert(title: "Invalid URL", message: "The url attached to this user is invalid.")
            return
        }
        
        view?.showSafari(with: url)
    }
}
