import UIKit
import GFNetwork
import GFStorage

enum ProfileAssembly {
    static func makeModule(
        with follower: Follower,
        profileModuleOutput: ProfileModuleOutput? = nil
    ) -> UIViewController {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(
            UserNetworkService(ImageLoader.shared),
            FavoritesStorageProvider.shared,
            follower
        )
        
        presenter.moduleOutput = profileModuleOutput
        viewController.output = presenter
        presenter.view = viewController
        
        return GFNavigationViewController(rootViewController: viewController)
    }
}
