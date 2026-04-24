//
//  EmptyStateView.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//

import UIKit
import SwiftUI

final class EmptyStateView: UIView {

    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    private let stackView = UIStackView()

    init(
        image: UIImage?,
        message: String
    ) {
        super.init(frame: .zero)
        imageView.image = image
        messageLabel.text = message
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        // Image styling
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 44,
            weight: .regular
        )

        // Label styling
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        // StackView
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(messageLabel)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }
}

//////////////////////////////////////////////////////////////
// MARK: - SwiftUI Preview (Blog App Example)
//////////////////////////////////////////////////////////////

struct EmptyStatePreview: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBackground

        let emptyView = EmptyStateView(
            image: UIImage(systemName: "doc.text.image"),
            message: "No blogs yet.\nTap + to create your first post."
        )

        container.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: container.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview("Empty Blog State") {
    EmptyStatePreview()
}
