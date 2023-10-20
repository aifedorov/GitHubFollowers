//
//  User.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

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
