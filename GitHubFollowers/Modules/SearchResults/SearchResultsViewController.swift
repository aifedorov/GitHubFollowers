//
//  SearchResultsViewController.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 16.05.23.
//

import UIKit

protocol SearchResultsViewOutput {
    func viewDidLoad()
    func loadImage(for userAvatarUrl: String) async -> Data?
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
        loadingView.color = .accentColor
        return loadingView
    }()
    
    private lazy var emptyStateView: StateView = {
        let view = StateView(with: "This user doesn’t exits or doesn’t have any followers",
                                  buttonTitle: "Open search screen",
                                  buttonAction: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        return view
    }()
    
    private lazy var fullScreenErrorView: StateView = {
        let view = StateView(with: "Something wrong, please, try again late",
                                  buttonTitle: "Open search screen",
                                  buttonAction: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
        
        setupCollectionView()
        
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        
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
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as! SearchResultCollectionViewCell
                        
            Task {
                if let data = await self.output?.loadImage(for: item.user.avatarUrl) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        
                        if let visibleCell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionViewCell,
                           self.dataSource.itemIdentifier(for: indexPath) == item {
                            let desplayData = SearchResultCollectionViewCell.DisplayData(text: item.user.login,
                                                                                         image: image)
                            visibleCell.configure(with: desplayData)
                        }
                    }
                }
            }
            
            let desplayData = SearchResultCollectionViewCell.DisplayData(text: item.user.login)
            cell.configure(with: desplayData)                    
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
        
    func showErrorMessageView() {
        collectionView.backgroundView = fullScreenErrorView
    }
    
    func hideErrorMessageView() {
        collectionView.backgroundView = emptyStateView
    }
    
    func showEmptyView() {
        collectionView.backgroundView = emptyStateView
    }
    
    func hideEmptyView() {
        collectionView.backgroundView = nil
    }
    
    func showLoadingView() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.stopAnimating()
    }
}
