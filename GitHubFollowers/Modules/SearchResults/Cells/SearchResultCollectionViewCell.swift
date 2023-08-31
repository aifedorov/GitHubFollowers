//
//  SearchResultCollectionViewCell.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 11.07.23.
//

import UIKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    struct DisplayData {
        let text: String
        let image: UIImage?
        
        init(text: String, image: UIImage? = nil) {
            self.text = text
            self.image = image
        }
    }
    
    static let cellIdentifier = String(describing: SearchResultCollectionViewCell.self)
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "mockAvatar")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
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
        
        addSubview(imageView)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -4),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),

            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
