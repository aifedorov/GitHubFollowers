import UIKit
import GFNetwork

enum FavoritesAssembly {
    static func makeModule() -> UIViewController {
        let viewController = FavoritesViewController()
        let presenter = FavoritesPresenter(
            FavoritesStorageProvider.shared,
            UserNetworkService(ImageLoader())
        )
        
        viewController.output = presenter
        presenter.view = viewController
        
        return GFNavigationViewController(rootViewController: viewController)
    }
}
