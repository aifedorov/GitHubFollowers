//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 27.09.23.
//

import Foundation

struct Follower: Decodable {
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
