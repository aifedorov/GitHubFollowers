//
//  SearchResultsPresenter.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 18.06.23.
//

import Foundation

protocol SearchResultsPresenterOutput: AnyObject {
    
}

final class SearchResultsPresenter {
    weak var view: SearchResultsPresenterOutput?
}

extension SearchResultsPresenter: SearchResultsViewOutput {
    
}
