import UIKit
import GFStorage
import GFCommon

protocol ProfileModuleOutput: AnyObject {
    func profileWantsToClose()
    func showFollowers(username: String)
}

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
        var userInfo: User?
        var isFavoriteButtonHighlighted = false
    }
    
    weak var view: ProfilePresenterOutput?
    weak var moduleOutput: ProfileModuleOutput?
    
    private let userNetworkService: UserNetworkServiceProtocol
    private let favoritesStorageProvider: FavoritesStorageProvider
    
    private var state: State {
        didSet {
            updateView()
        }
    }
    
    init(
        _ userNetworkService: UserNetworkServiceProtocol,
        _ favoritesStorageProvider: FavoritesStorageProvider,
        _ follower: Follower
    ) {
        self.userNetworkService = userNetworkService
        self.favoritesStorageProvider = favoritesStorageProvider
        self.state = State(
            follower: follower
        )
        
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        view?.updateFavoriteButton(isEnabled: false)
        Task { @MainActor in
            state.isFavoriteButtonHighlighted = await favoritesStorageProvider.storageProvider.contains(state.follower)
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
        let followingString = NSMutableAttributedString(string: "\(user.following) following")
        followersString.append(NSAttributedString(string: " "))
        followersString.append(followingString)
        return followersString
    }
    
    private func updateView() {
        guard let user = state.userInfo else { return }
        
        let followersDisplayData = GFBlockView.DisplayData(
            attributedText: makeFollowersString(for: user),
            buttonTitle:user.followers > 0 ? "Show followers" : "No followers",
            isEnabledButton: user.followers > 0
        )
        
        let reposString = NSMutableAttributedString(
            string: "\(user.publicRepos) repos",
            systemName: "book.pages"
        )
        let reposDisplayData = GFBlockView.DisplayData(
            attributedText: reposString,
            buttonTitle: "Open profile"
        )
        let onGitHubSince = "On Github from \(dateFormatter.string(from: user.createdAt))"
        let displayData = ProfileViewController.DisplayData(
            fullName: user.name ?? "",
            username: user.login,
            followers: followersDisplayData,
            repos: reposDisplayData,
            onGitHubSince: onGitHubSince
        )
        
        view?.showUserInfo(displayData)
        updateFavoriteButton()
    }
    
    private func showErrorAlertView(with alertContent: SearchResultErrorContent) {
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
                state.userInfo = user
            } catch {
                showErrorAlertView(with: .networkError)
            }
            
            view?.hideLoadingView()
        }
    }
    
    func didTapAddToFavoriteButton() {
        Task { @MainActor in
            let follower = state.follower
            if await !favoritesStorageProvider.storageProvider.contains(follower) {
                try await favoritesStorageProvider.storageProvider.save([follower])
            } else {
                try await favoritesStorageProvider.storageProvider.delete([follower])
            }
            
            updateFavoriteButton()
        }
    }
    
    func didTapCloseButton() {
        moduleOutput?.profileWantsToClose()
    }
    
    func didTapShowFollowersButton() {
        guard let user = state.userInfo else { return }
        moduleOutput?.showFollowers(username: user.login)
    }
    
    func didTapOpenProfileButton() {
        guard let user = state.userInfo, let url = URL(string: user.htmlUrl) else {
            view?.showErrorAlert(title: "Invalid URL", message: "The url attached to this user is invalid.")
            return
        }
        
        view?.showSafari(with: url)
    }
}
