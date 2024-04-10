import Foundation

struct Follower: Codable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
}

extension Follower: Equatable {
    static func == (lhs: Follower, rhs: Follower) -> Bool {
        lhs.id == rhs.id
    }
}
