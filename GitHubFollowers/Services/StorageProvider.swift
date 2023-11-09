//
//  StorageProvider.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 05.11.23.
//

import Foundation

actor StorageProvider {
    static let shared = StorageProvider()
    private init() {}
    
    private(set) var savedFollowers: [Follower] = []
    
    func addToFavorite(_ follower: Follower) {
        savedFollowers.append(follower)
    }
    
    func removeFromFavorite(_ follower: Follower) {
        guard let index = savedFollowers.firstIndex(where: { $0 == follower }) else { return }
        savedFollowers.remove(at: index)
    }
    
    func containsInFavorites(_ follower: Follower) -> Bool {
        savedFollowers.contains(where: { $0 == follower })
    }
}
