//
//  SearchResultCollectionViewCell.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 11.07.23.
//

import UIKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: SearchResultCollectionViewCell.self)
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var iconImageView: UIView = {
        let imageView = UIView(frame: .zero)
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
    
    func configure(with user: User) {
        textLabel.text = user.login
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: 4),

            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
