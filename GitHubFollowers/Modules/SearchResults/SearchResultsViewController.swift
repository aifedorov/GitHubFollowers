import UIKit

protocol SearchResultsViewOutput {
    func viewDidLoad()
    func fetchImage(at indexPath: IndexPath) async -> Data?
    func didSelectItem(at indexPath: IndexPath)
    func searchQueryDidChange(query: String)
}

final class SearchResultsViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
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
    
    var output: SearchResultsViewOutput?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private var displayItems: [Item] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    private let loadingView = GFLoadingView()
    
    private lazy var emptyView: GFEmptyView = {
        GFEmptyView(
            buttonAction: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
        )
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
        view.backgroundColor = .brand
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
        collectionViewLayout.itemSize = CGSize(width: 100, height: 130)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 16, left: 30, bottom: 16, right: 30)
        return collectionViewLayout
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: makeCollectionViewLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.cellId)
    }
    
    private func configureCollectionViewCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: Item
    ) -> UICollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FollowerCell.cellId,
            for: indexPath
        ) as? FollowerCell
        else {
            assertionFailure("Wrong table view cell type")
            return nil
        }
        
        let displayData = FollowerCell.DisplayData(text: item.username)
        cell.configure(with: displayData)
        
        Task { [weak cell] in
            guard let cell, let data = await self.output?.fetchImage(at: indexPath) else { return }
            let image = UIImage(data: data)
            let displayData = FollowerCell.DisplayData(text: item.username, image: image)
            
            await MainActor.run {
                guard collectionView.indexPath(for: cell) == indexPath else { return }
                cell.configure(with: displayData)
            }
        }
        
        return cell
    }
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: configureCollectionViewCell)
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
    
    func showErrorAlert(title: String, message: String) {
        presentAlert(title: title, message: message, type: .error)
    }
    
    func showEmptyView(withTile title: String, message: String, imageType: GFEmptyView.ImageType) {
        emptyView.update(title: title, message: message, imageType: imageType)
        collectionView.backgroundView = emptyView
    }
    
    func hideEmptyView() {
        collectionView.backgroundView = nil
    }
    
    func showLoadingView() {
        loadingView.startLoading()
        loadingView.isHidden = false
    }
    
    func hideLoadingView() {
        loadingView.stopLoading()
        loadingView.isHidden = true
    }
    
    func showProfile(for follower: Follower, profileModuleOutput: ProfileModuleOutput) {
        searchController.isActive = false
        let profileViewController = ProfileAssembly.makeModule(
            with: follower,
            profileModuleOutput: profileModuleOutput
        )
        present(profileViewController, animated: true)
    }
    
    func closeProfile(completion: (() -> Void)?) {
        presentedViewController?.dismiss(animated: true, completion: completion)
    }
    
    func updateTitle(username: String) {
        title = username
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        output?.searchQueryDidChange(query: query)
    }
}
