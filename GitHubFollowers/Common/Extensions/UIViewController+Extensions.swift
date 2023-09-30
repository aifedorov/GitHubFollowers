//
//  UIViewController+Extensions.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 28.09.23.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, type: CGAlertViewController.AlertType) {
        let alertViewController = CGAlertViewController(alertTitle: title, message: message, type: type)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        present(alertViewController, animated: true)
    }
}
