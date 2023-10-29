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
