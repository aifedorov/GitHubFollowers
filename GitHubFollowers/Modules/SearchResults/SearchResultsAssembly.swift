import UIKit
import GFNetwork

protocol SearchResultsModuleInput: AnyObject {
    func showFollowers(username: String)
}

enum SearchResultsAssembly {
    static func makeModule(searchedUsername: String) -> UIViewController {
        let viewController = SearchResultsViewController()
        viewController.title = searchedUsername
        let presenter = SearchResultsPresenter(searchedUsername: searchedUsername,
                                               UserNetworkService(ImageLoader.shared))
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
