//
//  GFNetworkService.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

import Foundation

protocol UserNetworkServiceProtocol {
    func fetchFollowers(for username: String) async throws -> [Follower]
    func fetchAvatarImage(fromURL avatarUrlString: String) async throws -> Data
    func fetchUserInfo(for username: String) async throws -> User
}

final class UserNetworkService: BaseNetworkService, UserNetworkServiceProtocol {
    private let imageLoader: ImageLoader
    
    init(_ imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        super.init(URLSession.shared, decoder)
    }
    
    func fetchFollowers(for username: String) async throws -> [Follower] {
        let urlString = "https://api.github.com/users/\(username)/followers"
        return try await fetch(from: urlString)
    }
    
    func fetchAvatarImage(fromURL avatarUrlString: String) async throws -> Data {
        return try await imageLoader.downloadImage(from: avatarUrlString)
    }
    
    func fetchUserInfo(for username: String) async throws -> User {
        let urlString = "https://api.github.com/users/\(username)"
        return try await fetch(from: urlString)
    }
}
