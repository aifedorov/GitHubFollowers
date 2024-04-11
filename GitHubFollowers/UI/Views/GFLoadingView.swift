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
        backgroundColor = .brand
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(activityIndicator)
        
        activityIndicator.pinToEdgesSuperview(
            top: 16,
            leading: 16,
            trailing: -16,
            bottom: -16,
            withSafeArea: false
        )
    }
    
    func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
