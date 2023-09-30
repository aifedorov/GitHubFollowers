//
//  SearchResultCell.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 11.07.23.
//

import UIKit

final class FollowerCell: UICollectionViewCell {
    
    struct DisplayData {
        let text: String
        let image: UIImage?
        
        init(text: String, image: UIImage? = nil) {
            self.text = text
            self.image = image
        }
    }
    
    static let cellId = String(describing: FollowerCell.self)
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "avatar_placeholder")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with displayData: DisplayData) {
        textLabel.text = displayData.text
        
        guard let image = displayData.image else { return }
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
        imageView.image = UIImage(named: "placeholder")
    }
    
    private func setupViews() {
        
        imageView.layer.cornerRadius = 12.0
        imageView.layer.masksToBounds = true
        
        addSubviews([imageView, textLabel])
        
        imageView.pinToEdgesSuperview(top: 0, leading: 0, trailing: 0, withSafeArea: false)
        imageView.fixSize(width: 100, height: 100)
        
        textLabel.pinToEdgesSuperview(leading: 8, trailing: 8, bottom: 0, withSafeArea: false)
        
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -4),
        ])
    }
}
