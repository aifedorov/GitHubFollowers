//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 23.05.23.
//

import Foundation

enum NetworkErrors: Error {
    case invalidateURL
    case wrongResponse
    case invalidateJSON(Error)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchFollowers(for userLogin: String) async throws -> [User] {
        guard let url = URL(string: "https://api.github.com/users/\(userLogin)/followers") else {
            throw NetworkErrors.invalidateURL
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw NetworkErrors.wrongResponse
            }
            
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            throw NetworkErrors.invalidateJSON(error)
        }
    }
}
