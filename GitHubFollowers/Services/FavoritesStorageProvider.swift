import Foundation
import GFStorage

final class FavoritesStorageProvider {
    
    static let shared = FavoritesStorageProvider()
    
    let storageProvider: StorageProvider<Follower>
    private let fileStorageService: FileStorageService<Follower>
    
    private init() {
        self.fileStorageService = FileStorageService<Follower>()
        self.storageProvider = StorageProvider<Follower>(fileStorageService)
    }
}
