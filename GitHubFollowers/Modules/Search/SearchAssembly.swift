import UIKit

enum SearchAssembly {
    static func makeModule() -> UIViewController {
        let viewController = SearchViewController()
        let presenter = SearchPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        
        return GFNavigationViewController(rootViewController: viewController)
    }
}
