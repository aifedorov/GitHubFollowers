import UIKit

final class GFUsernameLabel: UILabel {
    
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
        font = .systemFont(ofSize: 16, weight: .semibold)
        textColor = .label
    }
}
