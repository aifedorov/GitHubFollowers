import UIKit

protocol FavoritesViewOutput: AnyObject {
    func viewWillAppear()
    func fetchImage(at indexPath: IndexPath) async -> Data?
    func didSelectRow(at indexPath: IndexPath)
}

final class FavoritesViewController: UIViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Item>
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
    
    var output: FavoritesViewOutput?
    
    private lazy var emptyView: GFEmptyView = {
        GFEmptyView(
            withTitle: "No favorites",
            message: "You haven’t added any users yet.",
            image: .noFavorites
        )
    }()
    
    private var tableView: UITableView!
    private var dataSource: DataSource!
    private var displayItems: [Item] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupDataSource()
        
        view.addSubview(tableView)
        tableView.pinToEdgesSuperview(top: 0, leading: 0, trailing: 0, bottom: 0, withSafeArea: true)
        
        updateSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
    
    private func configureTableViewCell(tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.cellId, for: indexPath) as? FavoriteCell else {
            assertionFailure("Wrong table view cell type")
            return nil
        }
        
        let displayData = FavoriteCell.DisplayData(title: item.username)
        cell.configure(with: displayData)
        
        Task { [weak cell] in
            guard let cell, let data = await output?.fetchImage(at: indexPath) else { return }
            let image = UIImage(data: data)
            let displayData = FavoriteCell.DisplayData(title: item.username, avatarImage: image)
            
            await MainActor.run {
                guard tableView.indexPath(for: cell) == indexPath else { return }
                cell.configure(with: displayData)
            }
        }
        
        return cell
    }
    
    private func setupDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: configureTableViewCell)
    }
        
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.cellId)
        tableView.delegate = self
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(displayItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FavoritesViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output?.didSelectRow(at: indexPath)
    }
}

extension FavoritesViewController: FavoritesPresenterOutput {
    
    func showFavorites(_ followers: [Follower]) {
        displayItems = followers.map(Item.init)
    }
    
    func showEmptyView(withTile title: String, message: String, imageType: GFEmptyView.ImageType) {
        emptyView.update(title: title, message: message, imageType: imageType)
        tableView.backgroundView = emptyView
    }
    
    func hideEmptyView() {
        tableView.backgroundView = nil
        navigationController?.isNavigationBarHidden = false
    }
    
    func showErrorAlert(title: String, message: String) {
        presentAlert(title: title, message: message, type: .error)
    }
    
    func showProfile(for follower: Follower, profileModuleOutput: ProfileModuleOutput) {
        let profileViewController = ProfileAssembly.makeModule(with: follower, profileModuleOutput: profileModuleOutput)
        present(profileViewController, animated: true)
    }
    
    func closeProfile(completion: @escaping () -> Void) {
        presentedViewController?.dismiss(animated: true, completion: completion)
    }
    
    func showFollowers(username: String) {
        presentedViewController?.dismiss(animated: false)
        let searchResultsViewController = SearchResultsAssembly.makeModule(searchedUsername: username)
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
}
