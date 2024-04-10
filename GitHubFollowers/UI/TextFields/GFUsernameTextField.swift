import UIKit

final class GFUsernameTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupView(placeholder: "Enter Username")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(placeholder: "Enter text")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(placeholder: String) {
        autocorrectionType = .no
        borderStyle = .roundedRect
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor : UIColor.placeholderText])
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 24, weight: .medium)
        backgroundColor = .secondarySystemBackground
        
        returnKeyType = .search
        autocapitalizationType = .none
    }
}
