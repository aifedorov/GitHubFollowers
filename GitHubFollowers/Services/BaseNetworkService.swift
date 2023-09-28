//
//  BaseNetworkService.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 16.09.23.
//

import Foundation

class BaseNetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(_ session: URLSession = URLSession.shared, _ decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetch<Resource: Decodable>(from urlString: String) async throws -> Resource {
        guard let url = URL(string: urlString) else {
           throw GFNetworkError.invalidateURL(urlString)
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GFNetworkError.wrongResponse
        }
        
        guard httpResponse.statusCode != 404 else {
            throw GFNetworkError.resourceNotFound
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw GFNetworkError.wrongResponse
        }
        
        do {
            return try decoder.decode(Resource.self, from: data)
        } catch let error as DecodingError {
            throw GFNetworkError.invalidateJSON(error)
        } catch {
            throw GFNetworkError.unknown(error)
        }
    }
}
