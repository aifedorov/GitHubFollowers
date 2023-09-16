//
//  GFImageLoader.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 12.07.23.
//

import Foundation

protocol GFImageLoaderProtocol {
    func downloadImage(from urlString: String) async throws -> Data
}

final class GFImageLoader {
    
    static let shared = GFImageLoader()
    
    private let session: URLSession
    private let imageDataCache = NSCache<NSString, NSData>()
    
    init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidateURL(urlString)
        }
        
        let key = urlString as NSString
        if let data = imageDataCache.object(forKey: key) {
            return data as Data
        }

        let (data, response) = try await session.data(from: url)
        
        guard
            let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode) else {
            throw NetworkError.wrongResponse
        }
        
        let value = data as NSData
        imageDataCache.setObject(value, forKey: key)
        
        return data
    }
}
