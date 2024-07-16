import Foundation
import GFNetwork
import UIKit

final class FakeUserNetworkService: BaseNetworkService, UserNetworkServiceProtocol {
    
    private let imageLoader: ImageLoaderProtocol
    
    init(_ imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
    }
    
    func fetchFollowers(for username: String) async throws -> [Follower] {
        .mock
    }
    
    func fetchAvatarImage(fromURL avatarUrlString: String) async throws -> Data {
        try await imageLoader.downloadImage(from: "")
    }
    
    func fetchUserInfo(for username: String) async throws -> User {
        .mock
    }
}
