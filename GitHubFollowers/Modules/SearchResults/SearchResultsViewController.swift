//
//  SearchResultsViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 16.05.23.
//

import UIKit

protocol SearchResultsViewOutput {
    func viewDidLoad()
    func fetchImage(at indexPath: IndexPath) async -> Data?
    func didSelectItem(at indexPath: IndexPath)
    func searchQueryDidChange(query: String)
}

final class SearchResultsViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    struct Item: Hashable {
        let id: Int
        let username: String
                
        init(_ follower: Follower) {
            self.id = follower.id
            self.username = follower.login
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    var output: SearchResultsViewOutput?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var displayItems: [Item] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .accentColor
        return loadingView
    }()
        
    private lazy var fullScreenErrorView: FullsScreenMessageView = {
        let view = FullsScreenMessageView(with: "Something wrong, please try again",
                             buttonTitle: "Open search screen",
                             buttonAction: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Enter username"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.returnKeyType = .search
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
        navigationItem.searchController = searchController
        
        setupCollectionView()
        setupDataSource()
        
        view.addSubviews([collectionView, loadingView])
        
        collectionView.pinToEdgesSuperview(top: 0, leading: 0, trailing: 0)
        collectionView.pinToEdgesSuperview(bottom: 0, withSafeArea: false)
        loadingView.pinToCenterSuperview(centerX: 0, centerY: 0)
        
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 100,
                                               height: 120)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 16,
                                                         left: 30,
                                                         bottom: 16,
                                                         right: 30)
        return collectionViewLayout
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: makeCollectionViewLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchResultCell.self,
                                forCellWithReuseIdentifier: SearchResultCell.cellIdentifier)
    }
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            guard let self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.cellIdentifier, for: indexPath) as! SearchResultCell
            
            Task {
                if let data = await self.output?.fetchImage(at: indexPath) {
                    let image = UIImage(data: data)
                    let displayData = SearchResultCell.DisplayData(text: item.username, image: image)
                    
                    DispatchQueue.main.async {
                        cell.configure(with: displayData)
                    }
                }
            }
            
            let displayData = SearchResultCell.DisplayData(text: item.username)
            cell.configure(with: displayData)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(displayItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.didSelectItem(at: indexPath)
    }
}

extension SearchResultsViewController: SearchResultsPresenterOutput {
    
    func showFollowers(_ followers: [Follower]) {
        displayItems = followers.map(Item.init)
    }
    
    func showFullScreenErrorMessageView(with message: String) {
        fullScreenErrorView.setup(text: message)
        collectionView.backgroundView = fullScreenErrorView
    }
        
    func hideFullScreenErrorMessageView() {
        collectionView.backgroundView = nil
    }
    
    func showLoadingView() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.stopAnimating()
    }
    
    func showProfile(for follower: Follower) {
        let profileViewController = ProfileAssembly.makeModule(with: follower)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        output?.searchQueryDidChange(query: query)
    }
}
