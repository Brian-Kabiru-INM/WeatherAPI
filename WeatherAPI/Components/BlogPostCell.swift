//
//  BlogPostCell.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//

import UIKit
import SwiftUI

// MARK: - Cell

final class BlogPostCell: UITableViewCell {

    static let identifier = "BlogPostCell"

    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let metadataLabel = UILabel()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        // Card
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Avatar
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .systemGray3
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 22

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 44),
            avatarImageView.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Title
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2

        // Body
        bodyLabel.font = .systemFont(ofSize: 15)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 2

        // Metadata
        metadataLabel.font = .systemFont(ofSize: 13)
        metadataLabel.textColor = .tertiaryLabel

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            bodyLabel,
            metadataLabel
        ])
        textStack.axis = .vertical
        textStack.spacing = 6

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(textStack)

        cardView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with post: BlogPost) {
        titleLabel.text = post.title.capitalized
        bodyLabel.text = post.body
        metadataLabel.text = "Post #\(post.id ?? 0) • User \(post.userId)"
    }
}

//////////////////////////////////////////////////////////////
// MARK: - SwiftUI Preview
//////////////////////////////////////////////////////////////

struct BlogPostCellPreview: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBackground

        let cell = BlogPostCell(style: .default, reuseIdentifier: BlogPostCell.identifier)

        let sample = BlogPost(
            userId: 3,
            id: 42,
            title: "building a reusable ios ui system",
            body: "This post explains how to structure reusable UIKit components that scale well across large applications."
        )

        cell.configure(with: sample)

        container.addSubview(cell)

        cell.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cell.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            cell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview("Blog Post Cell") {
    BlogPostCellPreview()
        .frame(height: 140)
}
