import UIKit

enum ToastStyle {
    case success
    case error

    var backgroundColor: UIColor {
        switch self {
        case .success:
            return .systemGreen
        case .error:
            return .systemRed
        }
    }
    var icon: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle")
        case .error:
            return UIImage(systemName: "exclamationmark.circle")
        }
    }
}

final class ToastView: UIView {
    private let messageLabel = UILabel()
    private let iconImageView = UIImageView()

    init(message: String, style: ToastStyle) {
        super.init(frame: .zero)
        messageLabel.text = message
        backgroundColor = style.backgroundColor.withAlphaComponent(0.95)
        iconImageView.image = style.icon
        iconImageView.tintColor = .white
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 14
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false

        // Configure label
        messageLabel.textColor = .white
        messageLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure IconImageView
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        addSubview(iconImageView)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            messageLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            // messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    func show(in view: UIView) {
        view.addSubview(self)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])

        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 2.0, options: [.curveEaseInOut], animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
