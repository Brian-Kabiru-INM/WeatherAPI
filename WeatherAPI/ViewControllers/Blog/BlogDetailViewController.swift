//
//  BlogDetailViewController.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

final class BlogDetailViewController: UIViewController {
    private let postIdField = TextField(placeholder: "Post ID")
    private let userIdField = TextField(placeholder: "User ID")
    private let titleField = TextField(placeholder: "Post Title")
    private let bodyField = LargeBodyTextView(placeholder: "Post body")
    private let updateButton = PrimaryButton(title: "Save Changes")
    private let deleteButton = PrimaryButton(title: "Delete Blog")
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let viewModel: BlogViewModel
    private var post: BlogViewModel.CreatedPost
    private let onUpdated: (BlogViewModel.CreatedPost) -> Void
    private let onDeleted: (BlogViewModel.CreatedPost) -> Void

    init(
        viewModel: BlogViewModel,
        post: BlogViewModel.CreatedPost,
        onUpdated: @escaping (BlogViewModel.CreatedPost) -> Void,
        onDeleted: @escaping (BlogViewModel.CreatedPost) -> Void
    ) {
        self.viewModel = viewModel
        self.post = post
        self.onUpdated = onUpdated
        self.onDeleted = onDeleted
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureActions()
        fillPostData()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Edit Blog"

        postIdField.keyboardType = .numberPad
        postIdField.isEnabled = false
        userIdField.keyboardType = .numberPad
        titleField.autocapitalizationType = .sentences

        deleteButton.backgroundColor = .systemRed
        activityIndicator.hidesWhenStopped = true
    }

    private func configureLayout() {
        let stack = UIStackView(arrangedSubviews: [
            postIdField,
            userIdField,
            titleField,
            bodyField,
            updateButton,
            deleteButton,
            activityIndicator
        ])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureActions() {
        updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    private func fillPostData() {
        postIdField.text = String(post.id)
        userIdField.text = String(post.userId)
        titleField.text = post.title
        bodyField.text = post.body
    }

    @objc private func updateTapped() {
        Task {
            setLoading(true)
            do {
                let updated = try await viewModel.updatePost(
                    post,
                    userIdText: userIdField.text ?? "",
                    title: titleField.text ?? "",
                    body: bodyField.text
                )
                post = updated
                onUpdated(updated)
                setLoading(false)
                showToast(message: "Blog updated", style: .success)
            } catch {
                setLoading(false)
                showToast(message: (error as? LocalizedError)?.errorDescription ?? "Failed to update blog.", style: .error)
            }
        }
    }

    @objc private func deleteTapped() {
        Task {
            setLoading(true)
            do {
                let deletingPost = post
                try await viewModel.deletePost(deletingPost)
                onDeleted(deletingPost)
                navigationController?.popViewController(animated: true)
            } catch {
                setLoading(false)
                showToast(message: (error as? LocalizedError)?.errorDescription ?? "Failed to delete blog.", style: .error)
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        updateButton.setLoading(isLoading)
        deleteButton.setLoading(isLoading)
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func showToast(message: String, style: ToastStyle) {
        let toast = ToastView(message: message, style: style)
        toast.show(in: view)
    }
}
