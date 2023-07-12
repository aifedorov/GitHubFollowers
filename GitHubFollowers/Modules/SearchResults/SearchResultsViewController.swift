//
//  SearchResultsViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 16.05.23.
//

import UIKit

protocol SearchResultsViewOutput {
    func viewDidLoad()
}

final class SearchResultsViewController: UIViewController {

    enum Section {
        case main
    }
    
    struct Item: Hashable {
        let id: UUID
        let user: User
        
        init(user: User) {
            self.id = UUID()
            self.user = user
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    var output: SearchResultsViewOutput?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource! {
        didSet {
            updateStapshot()
        }
    }
    
    private var followers: [User] = [] {
        didSet {
            updateStapshot()
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        loadingView.color = .accentColor
        return loadingView
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView(with: "This user doesn’t exits or doesn’t have any followers",
                                  buttonAction: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
        
        setupCollectionView()
        
        view.addSubview(loadingView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        output?.viewDidLoad()
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchResultCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as! SearchResultCollectionViewCell
            cell.configure(with: identifier.user)
            return cell
        })
    }
    
    private func updateStapshot(with animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        let items = followers.map { Item(user: $0) }
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension SearchResultsViewController: SearchResultsPresenterOutput {
    
    func showSearchResults(followers: [User]) {
        self.followers = followers
    }
        
    func showErrorMessageView(with text: String) {
        emptyStateView.removeFromSuperview()
    }
    
    func showEmptyView() {
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func showLoadingView() {
        emptyStateView.removeFromSuperview()
        loadingView.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.stopAnimating()
    }
}
