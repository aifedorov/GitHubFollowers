//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 27.09.23.
//

import Foundation

struct Follower: Decodable, Hashable {
    let login: String
    let avatarUrl: String
    let url: String
}
