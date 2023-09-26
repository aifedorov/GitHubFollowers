//
//  BigButton.swift
//  GithubFollowers
//
//  Created by Aleksandr Fedorov on 12.05.23.
//

import UIKit

final class BigButton: UIButton {
    
    private let _backgroundColor: UIColor
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.94, y: 0.94) : .identity
            }, completion: { _ in })
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            tintColorDidChange()
        }
    }
    
    init(title: String, backgroundColor: UIColor = .accentColor) {
        self._backgroundColor = backgroundColor
        super.init(frame: .zero)
        
        self.backgroundColor = _backgroundColor
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: [
            .foregroundColor : UIColor.primaryColor,
            .font : UIFont.systemFont(ofSize: 24, weight: .bold)
        ])
                
        setAttributedTitle(attributedTitle, for: .normal)
        
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        
        tintColorDidChange()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        if tintAdjustmentMode == .dimmed || !isEnabled {
            setTitleColor(.systemGray3, for: .normal)
            backgroundColor = .systemGray2
        } else {
            setTitleColor(.primaryColor, for: .normal)
            backgroundColor = _backgroundColor
        }
    }
}
