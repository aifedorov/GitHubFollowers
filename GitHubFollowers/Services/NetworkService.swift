//
//  NetworkService.swift
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

final class NetworkService {
    private let session: URLSession
    
    init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchFollowers(for userLogin: String,
                        jsonDecoder: JSONDecoder = JSONDecoder()) async throws -> Result<[User], NetworkError> {
        
        guard let url = URL(string: "https://api.github.com/users/\(userLogin)/followers") else {
            return .failure(.invalidateURL)
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return .failure(.wrongResponse)
        }
        
        do {
            let users = try jsonDecoder.decode([User].self, from: data)
            return .success(users)
        } catch {
            return .failure(.invalidateJSON(error))
        }
    }
}
