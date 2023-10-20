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
    case resourceNotFound
    case unknown(Error)
}

extension NetworkError {
    var description: String {
        switch self {
        case .invalidateJSON(let decodingError):
            return "Invalidate JSON data: \(decodingError.localizedDescription)."
        case .invalidateURL(let urlString):
            return "Invalidate url: \(urlString)."
        case .wrongResponse:
            return "Wrong response from server."
        case .resourceNotFound:
            return "Resource not found. Please, try again."
        case .unknown(let error):
            return "Unexpected error: \(error.localizedDescription)"
        }
    }
}

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
