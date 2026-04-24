//
//  CardHeaderView.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//

import UIKit
import SwiftUI

final class CardHeaderView: UIView {

    // MARK: - UI

    private let iconContainer = UIView()
    private let iconImageView = UIImageView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let textStack = UIStackView()
    private let containerStack = UIStackView()

    private let gradientLayer = CAGradientLayer()
    private var shimmerLayer: CAGradientLayer?

    // MARK: - State

    private(set) var isLoading = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 20
        layer.masksToBounds = true

        // Gradient background
        gradientLayer.colors = [
            UIColor(red: 0.08, green: 0.27, blue: 0.53, alpha: 1).cgColor,
            UIColor(red: 0.02, green: 0.71, blue: 0.73, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)

        // Shadow (applied to wrapper in VC ideally)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)

        // Icon
        iconContainer.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        iconContainer.layer.cornerRadius = 20

        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit

        iconContainer.addSubview(iconImageView)

        // Labels
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        subtitleLabel.numberOfLines = 0

        // Stacks
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        containerStack.axis = .horizontal
        containerStack.spacing = 12
        containerStack.alignment = .center

        containerStack.addArrangedSubview(iconContainer)
        containerStack.addArrangedSubview(textStack)

        addSubview(containerStack)

        // Layout
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        if shimmerLayer != nil {
            shimmerLayer?.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)
        }
    }

    // MARK: - Configure

    func configure(title: String,
                   subtitle: String,
                   icon: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = UIImage(systemName: icon)
    }

    // MARK: - Loading (Shimmer)

    func setLoading(_ loading: Bool) {
        isLoading = loading

        titleLabel.alpha = loading ? 0 : 1
        subtitleLabel.alpha = loading ? 0 : 1
        iconContainer.alpha = loading ? 0 : 1

        if loading {
            startShimmer()
        } else {
            stopShimmer()
            animateIconBounce()
        }
    }

    private func startShimmer() {
        stopShimmer()

        let shimmer = CAGradientLayer()
        shimmer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.7).cgColor,
            UIColor.clear.cgColor
        ]
        shimmer.locations = [0, 0.5, 1]
        shimmer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmer.endPoint = CGPoint(x: 1, y: 0.5)
        shimmer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)

        layer.addSublayer(shimmer)
        shimmerLayer = shimmer

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = 1.1
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        shimmer.add(animation, forKey: "shimmer")
    }

    private func stopShimmer() {
        shimmerLayer?.removeFromSuperlayer()
        shimmerLayer = nil
    }

    // MARK: - Animation

    private func animateIconBounce() {
        iconContainer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: []) {
            self.iconContainer.transform = .identity
        }
    }

    // MARK: - Collapse Support

    func updateCollapse(progress: CGFloat) {
        // 0 = expanded, 1 = collapsed
        let scale = 1 - (0.2 * progress)
        let alpha = 1 - progress

        containerStack.transform = CGAffineTransform(scaleX: scale, y: scale)
        containerStack.alpha = alpha
    }
}
struct CardHeaderPreview: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBackground

        let header = CardHeaderView()
        header.configure(
            title: "My Created Posts",
            subtitle: "Tap + to compose. Tap any post to edit or delete.",
            icon: "doc.text.fill"
        )

        container.addSubview(header)

        header.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            header.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            header.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        header.setLoading(true)

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview("Card Header") {
    CardHeaderPreview()
        .frame(height: 140)
}
