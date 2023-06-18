//
//  SearchResultsViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 16.05.23.
//

import UIKit

protocol SearchResultsViewOutput {

}

final class SearchResultsViewController: UIViewController {
    
    var output: SearchResultsViewOutput?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
    }
}

extension SearchResultsViewController: SearchResultsPresenterOutput {
    
}
