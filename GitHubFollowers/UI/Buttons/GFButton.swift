import UIKit

final class GFButton: UIButton {
    
    enum ControlSize {
        case big
        case small
    }
    
    private let _backgroundColor: UIColor
    private let controlSize: ControlSize
    private let title: String
    
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
    
    init(title: String, backgroundColor: UIColor = .accent, controlSize: ControlSize = .small) {
        self._backgroundColor = backgroundColor
        self.controlSize = controlSize
        self.title = title
        
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        tintColorDidChange()
    }
    
    private func setupView() {
        let fontSize: CGFloat
        switch controlSize {
        case .big:
            fontSize = 24
        case .small:
            fontSize = 16
        }
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: [
            .foregroundColor : UIColor.brand,
            .font : UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        ])
                
        setAttributedTitle(attributedTitle, for: .normal)
        
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
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
            setTitleColor(.brand, for: .normal)
            backgroundColor = _backgroundColor
        }
    }
}
