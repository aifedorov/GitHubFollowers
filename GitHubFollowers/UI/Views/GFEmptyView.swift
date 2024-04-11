import UIKit

final class GFEmptyView: UIView {
    
    enum ImageType {
        case userNotFound
        case noFollowers
        case noFavorites
        
        var image: UIImage {
            switch self {
            case .noFavorites:
                return UIImage(resource: .noFavorites)
            case .userNotFound:
                return UIImage(resource: .userNotFound)
            case .noFollowers:
                return UIImage(resource: .noFollowers)
            }
        }
    }
    
    private let title: String
    private let message: String
    private let buttonTitle: String?
    private let buttonAction: (() -> ())?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: CGTitleLabel = {
        let label = CGTitleLabel(text: self.title)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var messageLabel: GFBodyLabel = {
        let label = GFBodyLabel(text: self.message)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var actionButton: GFButton = {
        GFButton(title: self.buttonTitle ?? "")
    }()
    
    init(
        withTitle title: String = "",
        message: String = "",
        buttonTitle: String? = nil,
        buttonAction: (() -> ())? = nil,
        image imageType: ImageType? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        
        super.init(frame: .zero)
        
        if let image = imageType?.image {
            imageView.image = image
        } else {
            imageView.isHidden = true
        }
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String, message: String, imageType: GFEmptyView.ImageType?) {
        titleLabel.text = title
        messageLabel.text = message
        if let image = imageType?.image {
            imageView.image = image
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
    }
    
    private func setupView() {
        addSubviews([imageView, titleLabel, messageLabel, actionButton])
                
        actionButton.isHidden = buttonTitle == nil || buttonAction == nil
        actionButton.fixSize(width: 240, height: 52)
        actionButton.pinToCenterSuperview(centerX: 0)
        
        imageView.pinToCenterSuperview(centerX: 0)
        imageView.fixSize(width: 280, height: 280)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30)
        ])
        
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapActionButton(_ sender: UIButton) {
        buttonAction?()
    }
}
