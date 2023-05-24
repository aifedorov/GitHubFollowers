//
//  User.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

import Foundation

struct User: Decodable {
    let id: Int
    let login: String
    let avatar_url: String
    let url: String
}
