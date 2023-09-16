//
//  GFNetworkService.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

import Foundation

enum NetworkError: Error {
    case invalidateURL(String)
    case wrongResponse
    case invalidateJSON(Error)
}

protocol GFUserNetworkServiceProtocol {
    func fetchFollowers(for userLogin: String) async throws -> [User]
    func fetchCountFollowers(fromURL followersURLString: String) async throws -> Int
    func fetchAvatarImage(fromURL avatarUrlString: String) async throws -> Data
}

final class GFUserNetworkService: BaseNetworkService, GFUserNetworkServiceProtocol {
    private let imageLoader: GFImageLoader
    
    init(_ imageLoader: GFImageLoader) {
        self.imageLoader = imageLoader
    }
    
    func fetchFollowers(for userLogin: String) async throws -> [User] {
        let urlString = "https://api.github.com/users/\(userLogin)/followers"
        return try await fetch(from: urlString)
    }
    
    func fetchCountFollowers(fromURL followersURLString: String) async throws -> Int {
        let users: [User] = try await fetch(from: followersURLString)
        return users.count
    }
    
    func fetchAvatarImage(fromURL avatarUrlString: String) async throws -> Data {
        return try await imageLoader.downloadImage(from: avatarUrlString)
    }
}
