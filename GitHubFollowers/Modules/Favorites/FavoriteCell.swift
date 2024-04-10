import UIKit

final class FavoriteCell: UITableViewCell {

    struct DisplayData {
        let title: String
        let avatarImage: UIImage?
        
        init(title: String, avatarImage: UIImage? = nil) {
            self.title = title
            self.avatarImage = avatarImage
        }
    }
    
    static let cellId = String(describing: FavoriteCell.self)
    
    private lazy var titleLabel = CGTitleLabel()
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImage.avatarPlaceholder
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
            
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        avatarImageView.image = .avatarPlaceholder
    }
    
    func configure(with displayData: DisplayData) {
        titleLabel.text = displayData.title
        avatarImageView.image = displayData.avatarImage ?? .avatarPlaceholder
    }
    
    private func setupViews() {
        avatarImageView.layer.cornerRadius = 12.0
        avatarImageView.layer.masksToBounds = true
        
        addSubviews([avatarImageView, titleLabel])
        
        avatarImageView.pinToEdgesSuperview(leading: 8, withSafeArea: false)
        avatarImageView.fixSize(width: 64, height: 64)
        avatarImageView.pinToCenterSuperview(centerY: 0)
        
        titleLabel.pinToCenterSuperview(centerY: 0)
        
        NSLayoutConstraint.activate([
            avatarImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -16),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        
        // leading inset for imageView + width imageView + trailing inset
        separatorInset = UIEdgeInsets(top: 0, left: 8+64+16, bottom: 0, right: 0)
    }
}
