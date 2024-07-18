import Foundation
import GFNetwork

@MainActor
final class GithubFollowersModel: ObservableObject {
    
    @Published var username = ""
    @Published var followers: [Follower] = []
    
    let environment: AppEnvironment
    
    init(
        username: String =  "",
        followers: [Follower] = [],
        environment: AppEnvironment
    ) {
        self.username = username
        self.followers = followers
        self.environment = environment
    }
    
    func fetchFollowers() async throws {
        followers = try await environment.userNetworkService.fetchFollowers(for: username)
    }
    
    func fetchUserInfo(for username: String) async throws -> User {
        try await environment.userNetworkService.fetchUserInfo(for: username)
    }
}

#if DEBUG
extension GithubFollowersModel {
    static let mock = GithubFollowersModel(
        username: "Fake username",
        followers: .mock,
        environment: .mock
    )
}
#endif
