//
//  GFNetworkMockService.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 29.08.23.
//

import Foundation


final class GFNetworkMockService: GFNetworkServiceProtocol {
        
    func fetchFollowers(for userLogin: String) async throws -> Result<[User], NetworkError> {
        if userLogin == "empty" {
            return .success([])
        }
        
        if userLogin == "error" {
            return .failure(.wrongResponse)
        }
        
        guard let url = Bundle.main.url(forResource: "followers", withExtension: "json") else {
            return .failure(.invalidateURL)
        }
        
        let jsonData = try Data(contentsOf: url)
        
        do {
            let users = try JSONDecoder().decode([User].self, from: jsonData)
            return .success(users)
        } catch {
            return .failure(.invalidateJSON(error))
        }
    }
    
    func fetchIcon(for avatarUrl: String) async throws -> Data {
        return Data()
    }
}
