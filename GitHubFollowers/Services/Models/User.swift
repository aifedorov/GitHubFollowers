//
//  User.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

import Foundation

struct User: Decodable, Hashable {
    let id: Int
    let login: String
    let avatarUrl: String
    let profileUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
        case avatarUrl = "avatar_url"
        case profileUrl = "url"
    }
}
