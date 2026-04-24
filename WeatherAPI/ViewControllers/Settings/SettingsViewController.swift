//
//  SettingsViewController.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

final class SettingsViewController: UIViewController {
    private let topGradientView = UIView()
    private let topGradientLayer = CAGradientLayer()

    private let logoutCircle = UIView()
    private let logoutIcon = UIImageView()
    private let logoutLabel = UILabel()

    private let avatarContainer = UIView()
    private let avatarIcon = UIImageView()
    private let addBadge = UIView()
    private let addBadgeIcon = UIImageView()

    private let nameLabel = UILabel()
    private let seenLabel = UILabel()

    private let qrButton = UIButton(type: .system)
    private let qrIconCircle = UIView()
    private let qrIcon = UIImageView()
    private let qrLabel = UILabel()

    private let sheetView = UIView()
    private let listStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTopHeader()
        configureWhiteSheet()
        configureLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topGradientLayer.frame = topGradientView.bounds
    }

    private func configureView() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
    }

    private func configureTopHeader() {
        topGradientLayer.colors = [
            UIColor(red: 0.08, green: 0.27, blue: 0.53, alpha: 1).cgColor,
            UIColor(red: 0.02, green: 0.71, blue: 0.73, alpha: 1).cgColor
        ]
        topGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        topGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        topGradientView.layer.addSublayer(topGradientLayer)

        logoutCircle.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        logoutCircle.layer.cornerRadius = 18

        logoutIcon.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        logoutIcon.tintColor = .white
        logoutIcon.contentMode = .scaleAspectFit

        logoutLabel.text = "Logout"
        logoutLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        logoutLabel.textColor = .white

        avatarContainer.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        avatarContainer.layer.cornerRadius = 14

        avatarIcon.image = UIImage(systemName: "person")
        avatarIcon.tintColor = .white
        avatarIcon.contentMode = .scaleAspectFit

        addBadge.backgroundColor = .systemTeal
        addBadge.layer.cornerRadius = 8
        addBadge.layer.borderColor = UIColor.white.cgColor
        addBadge.layer.borderWidth = 1.2

        addBadgeIcon.image = UIImage(systemName: "plus")
        addBadgeIcon.tintColor = .white
        addBadgeIcon.contentMode = .scaleAspectFit

        nameLabel.text = "Brian Kabiru"
        nameLabel.font = .systemFont(ofSize: 37, weight: .bold)
        nameLabel.textColor = .white

        seenLabel.text = "Last seen at 9:23 am | Tuesday 21"
        seenLabel.font = .systemFont(ofSize: 14, weight: .medium)
        seenLabel.textColor = UIColor.white.withAlphaComponent(0.95)

        qrButton.backgroundColor = UIColor(red: 0.02, green: 0.19, blue: 0.48, alpha: 1)
        qrButton.layer.cornerRadius = 22
        qrButton.contentHorizontalAlignment = .leading
        qrButton.addTarget(self, action: #selector(open404), for: .touchUpInside)

        qrIconCircle.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        qrIconCircle.layer.cornerRadius = 15

        qrIcon.image = UIImage(systemName: "qrcode")
        qrIcon.tintColor = UIColor(red: 0.05, green: 0.14, blue: 0.34, alpha: 1)

        qrLabel.text = "Scan to Log In to OTG Web"
        qrLabel.font = .systemFont(ofSize: 13, weight: .medium)
        qrLabel.textColor = .white

        view.addSubview(topGradientView)
        topGradientView.addSubview(logoutCircle)
        logoutCircle.addSubview(logoutIcon)
        topGradientView.addSubview(logoutLabel)
        topGradientView.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarIcon)
        avatarContainer.addSubview(addBadge)
        addBadge.addSubview(addBadgeIcon)
        topGradientView.addSubview(nameLabel)
        topGradientView.addSubview(seenLabel)
        topGradientView.addSubview(qrButton)
        qrButton.addSubview(qrIconCircle)
        qrIconCircle.addSubview(qrIcon)
        qrButton.addSubview(qrLabel)

        [topGradientView, logoutCircle, logoutIcon, logoutLabel, avatarContainer, avatarIcon, addBadge, addBadgeIcon, nameLabel, seenLabel, qrButton, qrIconCircle, qrIcon, qrLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureWhiteSheet() {
        sheetView.backgroundColor = .white
        sheetView.layer.cornerRadius = 22
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        listStack.axis = .vertical
        listStack.spacing = 0

        view.addSubview(sheetView)
        sheetView.addSubview(listStack)

        sheetView.translatesAutoresizingMaskIntoConstraints = false
        listStack.translatesAutoresizingMaskIntoConstraints = false

        listStack.addArrangedSubview(makeServicesCard())
        addSimpleRow(icon: "lock", title: "Account & Security")
        addSimpleRow(icon: "wallet.pass", title: "Account Management")
        addSimpleRow(icon: "bell", title: "Notifications", badgeText: "2")
        addSimpleRow(icon: "person", title: "Support")
        addSimpleRow(icon: "face.smiling", title: "Feedback")
        addSimpleRow(icon: "doc.text", title: "Legal")
    }

    private func makeServicesCard() -> UIView {
        let wrapper = UIControl()
        wrapper.addTarget(self, action: #selector(open404), for: .touchUpInside)
        wrapper.translatesAutoresizingMaskIntoConstraints = false

        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 13
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 8
        card.layer.shadowOffset = CGSize(width: 0, height: 2)

        let iconBox = UIView()
        iconBox.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        iconBox.layer.cornerRadius = 10

        let icon = UIImageView(image: UIImage(systemName: "briefcase"))
        icon.tintColor = .systemBlue
        icon.contentMode = .scaleAspectFit

        let title = UILabel()
        title.text = "Services"
        title.font = .systemFont(ofSize: 20, weight: .bold)

        let subtitle = UILabel()
        subtitle.text = "Get more tailor-made products for you"
        subtitle.font = .systemFont(ofSize: 13, weight: .regular)
        subtitle.textColor = .gray

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .black

        let labels = UIStackView(arrangedSubviews: [title, subtitle])
        labels.axis = .vertical
        labels.spacing = 2

        wrapper.addSubview(card)
        card.addSubview(iconBox)
        iconBox.addSubview(icon)
        card.addSubview(labels)
        card.addSubview(chevron)

        [card, iconBox, icon, labels, chevron].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            wrapper.heightAnchor.constraint(equalToConstant: 88),

            card.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 10),
            card.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 18),
            card.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -18),
            card.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -2),

            iconBox.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconBox.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            iconBox.widthAnchor.constraint(equalToConstant: 40),
            iconBox.heightAnchor.constraint(equalToConstant: 40),

            icon.centerXAnchor.constraint(equalTo: iconBox.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBox.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),

            labels.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            labels.leadingAnchor.constraint(equalTo: iconBox.trailingAnchor, constant: 10),
            labels.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -8),

            chevron.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            chevron.widthAnchor.constraint(equalToConstant: 10)
        ])

        return wrapper
    }

    private func addSimpleRow(icon: String, title: String, badgeText: String? = nil) {
        let row = UIControl()
        row.addTarget(self, action: #selector(open404), for: .touchUpInside)
        row.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .black
        iconView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .black

        let divider = UIView()
        divider.backgroundColor = UIColor.systemGray5

        row.addSubview(iconView)
        row.addSubview(titleLabel)
        row.addSubview(chevron)
        row.addSubview(divider)

        [iconView, titleLabel, chevron, divider].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        if let badgeText {
            let badge = UILabel()
            badge.text = badgeText
            badge.textColor = .white
            badge.backgroundColor = .systemRed
            badge.font = .systemFont(ofSize: 10, weight: .bold)
            badge.textAlignment = .center
            badge.layer.cornerRadius = 9
            badge.clipsToBounds = true
            badge.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(badge)

            NSLayoutConstraint.activate([
                badge.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                badge.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -12),
                badge.widthAnchor.constraint(equalToConstant: 18),
                badge.heightAnchor.constraint(equalToConstant: 18)
            ])
        }

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 50),

            iconView.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 30),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),

            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),

            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -28),
            chevron.widthAnchor.constraint(equalToConstant: 9),

            divider.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -20),
            divider.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])

        listStack.addArrangedSubview(row)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            topGradientView.topAnchor.constraint(equalTo: view.topAnchor),
            topGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topGradientView.bottomAnchor.constraint(equalTo: sheetView.topAnchor, constant: 22),

            logoutCircle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoutCircle.trailingAnchor.constraint(equalTo: topGradientView.trailingAnchor, constant: -20),
            logoutCircle.widthAnchor.constraint(equalToConstant: 36),
            logoutCircle.heightAnchor.constraint(equalToConstant: 36),

            logoutIcon.centerXAnchor.constraint(equalTo: logoutCircle.centerXAnchor),
            logoutIcon.centerYAnchor.constraint(equalTo: logoutCircle.centerYAnchor),
            logoutIcon.widthAnchor.constraint(equalToConstant: 16),
            logoutIcon.heightAnchor.constraint(equalToConstant: 16),

            logoutLabel.centerYAnchor.constraint(equalTo: logoutCircle.centerYAnchor),
            logoutLabel.leadingAnchor.constraint(equalTo: logoutCircle.trailingAnchor, constant: 6),
            logoutLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),

            avatarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            avatarContainer.centerXAnchor.constraint(equalTo: topGradientView.centerXAnchor),
            avatarContainer.widthAnchor.constraint(equalToConstant: 62),
            avatarContainer.heightAnchor.constraint(equalToConstant: 62),

            avatarIcon.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarIcon.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarIcon.widthAnchor.constraint(equalToConstant: 20),
            avatarIcon.heightAnchor.constraint(equalToConstant: 20),

            addBadge.centerXAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
            addBadge.centerYAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
            addBadge.widthAnchor.constraint(equalToConstant: 16),
            addBadge.heightAnchor.constraint(equalToConstant: 16),

            addBadgeIcon.centerXAnchor.constraint(equalTo: addBadge.centerXAnchor),
            addBadgeIcon.centerYAnchor.constraint(equalTo: addBadge.centerYAnchor),
            addBadgeIcon.widthAnchor.constraint(equalToConstant: 12),
            addBadgeIcon.heightAnchor.constraint(equalToConstant: 12),

            nameLabel.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: topGradientView.centerXAnchor),

            seenLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            seenLabel.centerXAnchor.constraint(equalTo: topGradientView.centerXAnchor),

            qrButton.topAnchor.constraint(equalTo: seenLabel.bottomAnchor, constant: 14),
            qrButton.centerXAnchor.constraint(equalTo: topGradientView.centerXAnchor),
            qrButton.widthAnchor.constraint(equalToConstant: 265),
            qrButton.heightAnchor.constraint(equalToConstant: 44),

            qrIconCircle.leadingAnchor.constraint(equalTo: qrButton.leadingAnchor, constant: 8),
            qrIconCircle.centerYAnchor.constraint(equalTo: qrButton.centerYAnchor),
            qrIconCircle.widthAnchor.constraint(equalToConstant: 30),
            qrIconCircle.heightAnchor.constraint(equalToConstant: 30),

            qrIcon.centerXAnchor.constraint(equalTo: qrIconCircle.centerXAnchor),
            qrIcon.centerYAnchor.constraint(equalTo: qrIconCircle.centerYAnchor),
            qrIcon.widthAnchor.constraint(equalToConstant: 16),
            qrIcon.heightAnchor.constraint(equalToConstant: 16),

            qrLabel.centerYAnchor.constraint(equalTo: qrButton.centerYAnchor),
            qrLabel.leadingAnchor.constraint(equalTo: qrIconCircle.trailingAnchor, constant: 10),

            sheetView.topAnchor.constraint(equalTo: qrButton.bottomAnchor, constant: 18),
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            listStack.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 8),
            listStack.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            listStack.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            listStack.bottomAnchor.constraint(lessThanOrEqualTo: sheetView.bottomAnchor, constant: -8)
        ])
    }

    @objc private func open404() {
        let viewController = BuildViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
