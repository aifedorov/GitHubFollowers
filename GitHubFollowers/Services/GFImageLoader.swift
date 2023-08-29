//
//  GFImageLoader.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 12.07.23.
//

import Foundation


final class GFImageLoader {
    
    static let shared = GFImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    private init() {}
    
    func downloadImage(_ url: URL) async throws -> Data {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            return data as Data
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.wrongResponse
        }
        
        let value = data as NSData
        imageDataCache.setObject(value, forKey: key)
        
        return data
    }
}
