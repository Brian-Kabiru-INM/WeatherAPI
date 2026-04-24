//
//  BuildViewController.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

final class BuildViewController: UIViewController {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }

    private func configureView() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Settings"

        // Image
        imageView.image = UIImage(named: "Construction")
        imageView.contentMode = .scaleAspectFit

        // Title
        titleLabel.text = "Under Construction"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center

        // Subtitle
        subtitleLabel.text = "We're working on something great.\nCheck back soon."
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        // Stack
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        view.addSubview(stackView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([

            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        stackView.alpha = 0
        stackView.transform = CGAffineTransform(translationX: 0, y: 20)

        UIView.animate(withDuration: 0.4) {
            self.stackView.alpha = 1
            self.stackView.transform = .identity
        }
    }
}
