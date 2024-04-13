import UIKit
import GFNetwork
import GFStorage

enum FavoritesAssembly {
    static func makeModule() -> UIViewController {
        let viewController = FavoritesViewController()
        let fileStorageService = FileStorageService<Follower>()
        let presenter = FavoritesPresenter(
            storageProvider: StorageProvider<Follower>(fileStorageService),
            userNetworkService: UserNetworkService(ImageLoader.shared)
        )
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
