import Foundation

@MainActor
@Observable
final class UserStore {
    
    var username = ""
    var searchText = ""
    
    var filteredFollowers: [Follower] {
        followers.filter { $0.matches(searchText: searchText) }
    }
    
    private let environment: AppEnvironment
    private var followers: [Follower] = []
    
    init(
        username: String = "",
        environment: AppEnvironment
    ) {
        self.environment = environment
    }
    
    func fetchFollowers() async throws {
        followers = try await environment.userNetworkService.fetchFollowers(for: username)
    }
}

#if DEBUG
extension UserStore {
    static let mock = UserStore(
        username: "mockUsername",
        environment: .mock
    )
}
#endif
