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
    case invalidateJSON(DecodingError)
    case unknown(Error)
}

protocol GFUserNetworkServiceProtocol {
    func fetchFollowers(for username: String) async throws -> [Follower]
    func fetchAvatarImage(fromURL avatarUrlString: String) async throws -> Data
}

final class GFUserNetworkService: BaseNetworkService, GFUserNetworkServiceProtocol {
    private let imageLoader: GFImageLoader
    
    init(_ imageLoader: GFImageLoader) {
        self.imageLoader = imageLoader
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        super.init(URLSession.shared, decoder)
    }
    
    func fetchFollowers(for username: String) async throws -> [Follower] {
        let urlString = "https://api.github.com/users/\(username)/followers"
        return try await fetch(from: urlString)
    }
    
    func fetchAvatarImage(fromURL avatarUrlString: String) async throws -> Data {
        return try await imageLoader.downloadImage(from: avatarUrlString)
    }
}
