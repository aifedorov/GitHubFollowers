import UIKit

final class GFNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brand
        
        navigationBar.backgroundColor = .brand
        navigationBar.scrollEdgeAppearance = appearance
    }
}
