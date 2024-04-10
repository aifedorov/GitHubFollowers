import UIKit

final class GFBlockView: UIView {
    
    struct DisplayData {
        let attributedText: NSAttributedString
        let buttonTitle: String
        let isEnabledButton: Bool
        
        init(
            attributedText: NSAttributedString = .init(),
            buttonTitle: String = "",
            isEnabledButton: Bool = true
        ) {
            self.attributedText = attributedText
            self.buttonTitle = buttonTitle
            self.isEnabledButton = isEnabledButton
        }
    }
    
    private var displayData: DisplayData {
        didSet {
            titleLabel.attributedText = displayData.attributedText
            actionButton.setTitle(displayData.buttonTitle, for: .normal)
            actionButton.isEnabled = displayData.isEnabledButton
        }
    }
    private let buttonAction: () -> Void
    
    private lazy var titleLabel: GFBlockTitleLabel = {
        GFBlockTitleLabel(text: self.displayData.buttonTitle)
    }()
    
    private lazy var actionButton: GFButton = {
        GFButton(title: self.displayData.buttonTitle)
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .blockBackground
        return view
    }()
    
    init(displayData: DisplayData = DisplayData(), buttonAction: @escaping () -> Void) {
        self.displayData = displayData
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton() {
        buttonAction()
    }
    
    func configure(with displayData: DisplayData) {
        self.displayData = displayData
    }
    
    private func setupView() {
        containerView.addSubviews([titleLabel, actionButton])
        addSubview(containerView)
        
        containerView.pinToEdgesSuperview(top: 0, leading: 0, trailing: 0, bottom: 0, withSafeArea: false)
        titleLabel.pinToEdgesSuperview(top: 20, leading: 24, trailing: -24, withSafeArea: false)
        
        actionButton.pinToEdgesSuperview(leading: 24, trailing: -24, bottom: -20, withSafeArea: false)
        actionButton.pinToCenterSuperview(centerX: 0)
        actionButton.fixSize(height: 44)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18)
        ])
    }
}
