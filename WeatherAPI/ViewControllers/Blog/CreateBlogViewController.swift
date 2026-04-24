//
//  CreateBlogViewController.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

final class CreateBlogViewController: UIViewController {
    private let postIdField = TextField(placeholder: "Post ID")
    private let userIdField = TextField(placeholder: "User ID")
    private let titleField = TextField(placeholder: "Post Title")
    private let bodyField = LargeBodyTextView(placeholder: "Write your post body...")
    private let createButton = PrimaryButton(title: "Create Blog")
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let viewModel: BlogViewModel
    private let onCreated: (BlogViewModel.CreatedPost) -> Void

    init(viewModel: BlogViewModel, onCreated: @escaping (BlogViewModel.CreatedPost) -> Void) {
        self.viewModel = viewModel
        self.onCreated = onCreated
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
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "New Blog"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )

        postIdField.keyboardType = .numberPad
        userIdField.keyboardType = .numberPad
        titleField.autocapitalizationType = .sentences

        activityIndicator.hidesWhenStopped = true
    }

    private func configureLayout() {
        let stack = UIStackView(arrangedSubviews: [
            postIdField,
            userIdField,
            titleField,
            bodyField,
            createButton,
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
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func createTapped() {
        Task {
            setLoading(true)
            do {
                let post = try await viewModel.createPost(
                    postIdText: postIdField.text ?? "",
                    userIdText: userIdField.text ?? "",
                    title: titleField.text ?? "",
                    body: bodyField.text
                )
                onCreated(post)
                dismiss(animated: true)
            } catch {
                setLoading(false)
                showToast(message: (error as? LocalizedError)?.errorDescription ?? "Failed to create blog.", style: .error)
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        createButton.setLoading(isLoading)
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func showToast(message: String, style: ToastStyle) {
        let toast = ToastView(message: message, style: style)
        toast.show(in: view)
    }
}
