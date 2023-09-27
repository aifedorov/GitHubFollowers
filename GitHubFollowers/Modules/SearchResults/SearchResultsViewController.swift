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
}

final class SearchResultsViewController: UIViewController {

    enum Section {
        case main
    }
    
    struct Item: Hashable {
        let id: UUID
        let username: String
        
        init(username: String) {
            self.id = UUID()
            self.username = username
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    var output: SearchResultsViewOutput?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    
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
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.cellIdentifier,
                                                          for: indexPath) as! SearchResultCell
                        
            Task {
                if let data = await self.output?.fetchImage(at: indexPath) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        
                        if let visibleCell = collectionView.cellForItem(at: indexPath) as? SearchResultCell,
                           self.dataSource.itemIdentifier(for: indexPath) == item {
                            let displayData = SearchResultCell.DisplayData(text: item.username, image: image)
                            visibleCell.configure(with: displayData)
                        }
                    }
                }
            }
            
            let displayData = SearchResultCell.DisplayData(text: item.username)
            cell.configure(with: displayData)                    
            return cell
        })
    }
    
    private func updateSnapshot(_ items: [Item], with animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.didSelectItem(at: indexPath)
    }
}

extension SearchResultsViewController: SearchResultsPresenterOutput {
    
    func showSearchResults(_ followers: [Follower]) {
        updateSnapshot(followers.map { Item(username: $0.login) })
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
    
    func showProfile(for follower: Follower) {
        let profileViewController = ProfileAssembly.makeModule(with: follower)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
