import Foundation
import GFNetwork
import UIKit

final class FakeImageLoader: ImageLoaderProtocol {
            
    init(_ session: URLSession = URLSession.shared) {}
    
    func downloadImage(from urlString: String) async throws -> Data {
        UIImage(resource: .avatarPlaceholder).jpegData(compressionQuality: 1.0) ?? .init()
    }
}
