//
//  GFNetworkMockService.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 29.08.23.
//

import Foundation


final class GFNetworkMockService: GFNetworkServiceProtocol {
    
    func fetchFollowers(for userLogin: String) async throws -> Result<[User], NetworkError> {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            debugPrint("Document Directory:", documentDirectory)
        } else {
            debugPrint("Document Directory not found")
        }
        
        debugPrint("\(Bundle.main.resourceURL?.absoluteString ?? "")")
        
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
