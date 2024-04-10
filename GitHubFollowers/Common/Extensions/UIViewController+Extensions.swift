import UIKit
import SafariServices

extension UIViewController {
    func presentAlert(title: String, message: String, type: GFAlertViewController.AlertType) {
        let alertViewController = GFAlertViewController(alertTitle: title, message: message, type: type)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        present(alertViewController, animated: true)
    }
    
    func presentSafari(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .accent
        
        present(safariViewController, animated: true)
    }
}
