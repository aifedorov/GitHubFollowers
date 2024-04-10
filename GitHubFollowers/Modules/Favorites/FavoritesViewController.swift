import UIKit

protocol FavoritesViewOutput: AnyObject {
    func viewWillAppear()
    func fetchImage(at indexPath: IndexPath) async -> Data?
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
    
    private var tableView: UITableView!
    private var dataSource: DataSource!
    private var displayItems: [Item] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension FavoritesViewController: FavoritesPresenterOutput {
    
    func showFavorites(_ followers: [Follower]) {
        displayItems = followers.map(Item.init)
    }
}
