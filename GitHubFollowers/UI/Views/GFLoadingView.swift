import UIKit

final class GFLoadingView: UIView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .accent
        return loadingView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 36
        layer.shadowOffset = CGSize(width: 0, height: 8)
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        
        addSubview(activityIndicator)
        
        activityIndicator.pinToCenterSuperview(centerX: 0, centerY: 0)
    }
    
    func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
