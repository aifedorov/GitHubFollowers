//
//  GFNetworkService.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

import Foundation

enum NetworkError: Error {
    case invalidateURL
    case wrongResponse
    case invalidateJSON(Error)
}

protocol GFNetworkServiceProtocol {
    func fetchFollowers(for userLogin: String) async throws -> Result<[User], NetworkError>
    func fetchIcon(for avatarUrl: String) async throws -> Data
}

final class GFNetworkService: GFNetworkServiceProtocol {
    private let session: URLSession
    
    init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchFollowers(for userLogin: String) async throws -> Result<[User], NetworkError> {
        
        guard let url = URL(string: "https://api.github.com/users/\(userLogin)/followers") else {
            return .failure(.invalidateURL)
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return .failure(.wrongResponse)
        }
        
        do {
            let users = try JSONDecoder().decode([User].self, from: data)
            return .success(users)
        } catch {
            return .failure(.invalidateJSON(error))
        }
    }
    
    func fetchIcon(for avatarUrl: String) async throws -> Data {
        guard let url = URL(string: avatarUrl) else {
            throw NetworkError.invalidateURL
        }
        
        return try await GFImageLoader.shared.downloadImage(url)
    }
}
