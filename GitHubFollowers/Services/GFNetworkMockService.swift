//
//  GFNetworkMockService.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 29.08.23.
//

import Foundation

final class GFUserNetworkMockService: GFUserNetworkServiceProtocol {
    
    func fetchCountFollowers(fromURL followersURLString: String) async throws -> Int {
        return 12
    }
    
    func fetchFollowers(for userLogin: String) async throws -> [User] {
        if userLogin == "empty" {
            return []
        }
        
        if userLogin == "error" {
            throw NetworkError.wrongResponse
        }
        
        guard let url = Bundle.main.url(forResource: "followers", withExtension: "json") else {
            throw NetworkError.invalidateURL("followers.json")
        }
        
        let jsonData = try Data(contentsOf: url)
        
        do {
            return try JSONDecoder().decode([User].self, from: jsonData)
        } catch {
            throw NetworkError.invalidateJSON(error)
        }
    }
    
    func fetchAvatarImage(fromURL avatarUrl: String) async throws -> Data {
        return Data()
    }
}
