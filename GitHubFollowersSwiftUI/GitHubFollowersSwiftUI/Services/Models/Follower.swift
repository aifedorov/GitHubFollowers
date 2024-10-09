import Foundation

struct Follower: Decodable, Identifiable, Equatable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    
    func matches(searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        return login.localizedCaseInsensitiveContains(searchText)
    }
}

#if DEBUG
extension Follower {
    static let mock = Follower(
        id: 0,
        login: "user1",
        avatarUrl: "",
        url: ""
    )
}

extension Array where Element == Follower {
    
    static let mock = [
        Follower(
            id: 0,
            login: "user1",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 1,
            login: "user2",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 3,
            login: "user3",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 4,
            login: "user4",
            avatarUrl: "",
            url: ""
        ),
        Follower(
            id: 5,
            login: "user5",
            avatarUrl: "",
            url: ""
        )

    ]
}

#endif
