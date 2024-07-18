import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let name: String?
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let followers: Int
    let following: Int
    let publicRepos: Int
    let createdAt: Date
    
    var createdAtFormatted: String {
        createdAt.formatted(.dateTime.year())
    }
}

#if DEBUG
extension User {
    static let mock = User(
        id: 0,
        name: "Mock User",
        login: "mockUser",
        avatarUrl: "",
        htmlUrl: "",
        followers: 10,
        following: 10,
        publicRepos: 10,
        createdAt: Date()
    )
}
#endif
