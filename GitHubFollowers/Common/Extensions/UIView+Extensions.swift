import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func pinToEdgesSuperview(top: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, bottom: CGFloat? = nil, withSafeArea hasSafeArea: Bool = true) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top {
            if hasSafeArea {
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
            } else {
                topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
            }
        }
        if let leading {
            if hasSafeArea {
                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: leading).isActive = true
            } else {
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
            }
        }
        if let trailing {
            if hasSafeArea {
                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -trailing).isActive = true
            } else {
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing).isActive = true
            }
        }
        if let bottom {
            if hasSafeArea {
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -bottom).isActive = true
            } else {
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
            }
        }
    }
    
    func pinToCenterSuperview(centerX: CGFloat? = nil, centerY: CGFloat? = nil) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: centerX).isActive = true
        }
        if let centerY {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: centerY).isActive = true
        }
    }
    
    func fixSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
