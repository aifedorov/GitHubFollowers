import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let login: String
    let bio: String?
    let avatarUrl: String
    let htmlUrl: String
    let followers: Int
    let following: Int
    let publicRepos: Int
}

#if DEBUG
extension User {
    static let mock = User(
        id: 0,
        name: "Mock User",
        login: "mockUser",
        bio: "Mock bio",
        avatarUrl: "",
        htmlUrl: "",
        followers: 10,
        following: 10,
        publicRepos: 10
    )
}
#endif
