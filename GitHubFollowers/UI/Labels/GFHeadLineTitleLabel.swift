//
//  GFHeadLineTitleLabel.swift
//  GitHubFollowers
//
//  Created by Aleksandr Fedorov on 01.10.23.
//

import UIKit

final class GFHeadLineTitleLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        font = .systemFont(ofSize: 32, weight: .heavy)
        textColor = .brand
        textAlignment = .left
    }
}
