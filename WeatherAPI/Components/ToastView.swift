//
//  ToastView.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit
import SwiftUI

enum ToastStyle {
    case success
    case error

    var tintColor: UIColor {
        switch self {
        case .success:
            return .systemGreen
        case .error:
            return .systemRed
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor.systemGreen.withAlphaComponent(0.12)
        case .error:
            return UIColor.systemRed.withAlphaComponent(0.12)
        }
    }

    var icon: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle.fill")
        case .error:
            return UIImage(systemName: "xmark.octagon.fill")
        }
    }
}

final class ToastView: UIView {
    private let messageLabel = UILabel()
    private let iconImageView = UIImageView()
    private let stackView = UIStackView()

    init(message: String, style: ToastStyle) {
        super.init(frame: .zero)

        messageLabel.text = message
        iconImageView.image = style.icon
        iconImageView.tintColor = style.tintColor

        backgroundColor = style.backgroundColor

        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 18
        layer.masksToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0

        // Label styling (info card style)
        messageLabel.textColor = .label
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messageLabel.numberOfLines = 0

        // Icon styling
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)

        // Stack
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(messageLabel)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 26),
            iconImageView.heightAnchor.constraint(equalToConstant: 26),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    func show(in view: UIView) {
        view.addSubview(self)

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])

        transform = CGAffineTransform(translationX: 0, y: 20)

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.25,
                           delay: 2.5,
                           options: [.curveEaseInOut],
                           animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: 0, y: 20)
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}

// MARK: - SwiftUI Preview

struct ToastPreview: UIViewRepresentable {
    let message: String
    let style: ToastStyle

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBackground

        let toast = ToastView(message: message, style: style)
        container.addSubview(toast)

        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            toast.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 20),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -20)
        ])

        toast.alpha = 1

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview("Success Toast") {
    ToastPreview(
        message: "Your form was submitted successfully.",
        style: .success
    )
}

#Preview("Error Toast") {
    ToastPreview(
        message: "Something went wrong. Please try again.",
        style: .error
    )
}
