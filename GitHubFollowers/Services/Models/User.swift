//
//  User.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String?
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let followers: Int
    let following: Int
    let publicRepos: Int
    let createdAt: Date
}
