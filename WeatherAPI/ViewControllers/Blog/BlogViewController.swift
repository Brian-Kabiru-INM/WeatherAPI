//
//  BlogViewController.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

final class BlogViewController: UIViewController {

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refreshControl = UIRefreshControl()

    private let headerView = CardHeaderView()
    private let searchBar = BlogSearchBar()

    private let emptyStateView = EmptyStateView(
        image: UIImage(systemName: "doc.text.image"),
        message: "No blogs yet.\nTap + to create your first post."
    )

    private let fabButton = UIButton(type: .system)

    // MARK: - Data

    private let viewModel = BlogViewModel()
    private var hasPlayedInitialHeaderShimmer = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHeader()
        configureSearchBar()
        configureTable()
        configureFAB()
        configureLayout()
        refreshUI(animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playHeaderShimmerIfNeeded()
    }

    // MARK: - Setup

    private func configureView() {
        view.backgroundColor = .systemGroupedBackground
        // navigationItem.title = "My Blogs"
    }

    private func configureHeader() {
        headerView.configure(
            title: "My Created Posts",
            subtitle: "Tap + to compose. Tap any post to edit or delete.",
            icon: "doc.text.fill"
        )

        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
    }

    private func configureTable() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(BlogPostCell.self, forCellReuseIdentifier: BlogPostCell.identifier)

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120

        // Pull to refresh
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        view.addSubview(emptyStateView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureFAB() {
        fabButton.setImage(UIImage(systemName: "plus"), for: .normal)
        fabButton.tintColor = .white
        fabButton.backgroundColor = .cyanGreen
        fabButton.layer.cornerRadius = 28
        fabButton.layer.shadowColor = UIColor.black.cgColor
        fabButton.layer.shadowOpacity = 0.2
        fabButton.layer.shadowRadius = 6
        fabButton.layer.shadowOffset = CGSize(width: 0, height: 3)

        fabButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)

        view.addSubview(fabButton)
        fabButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateView.topAnchor.constraint(equalTo: tableView.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),

            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56),
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func playHeaderShimmerIfNeeded() {
        guard !hasPlayedInitialHeaderShimmer else { return }
        hasPlayedInitialHeaderShimmer = true

        headerView.setLoading(true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in
            self?.headerView.setLoading(false)
        }
    }

    // MARK: - Actions

    @objc private func addTapped() {
        let composer = CreateBlogViewController(viewModel: viewModel) { [weak self] _ in
            self?.refreshUI(animated: true)
            self?.showToast(message: "Blog created", style: .success)
        }

        let nav = UINavigationController(rootViewController: composer)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }

    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.refreshUI(animated: false)
            self.refreshControl.endRefreshing()
        }
    }

    private func openDetail(for post: BlogViewModel.CreatedPost) {
        let detail = BlogDetailViewController(
            viewModel: viewModel,
            post: post,
            onUpdated: { [weak self] _ in self?.refreshUI(animated: true) },
            onDeleted: { [weak self] _ in
                self?.refreshUI(animated: true)
                self?.showToast(message: "Blog deleted", style: .success)
            }
        )
        navigationController?.pushViewController(detail, animated: true)
    }

    // MARK: - UI Updates

    private func refreshUI(animated: Bool) {
        tableView.reloadData()

        let isEmpty = viewModel.createdPosts.isEmpty
        emptyStateView.isHidden = !isEmpty

        guard animated else { return }

        emptyStateView.alpha = isEmpty ? 0 : 1
        UIView.animate(withDuration: 0.3) {
            self.emptyStateView.alpha = isEmpty ? 1 : 0
        }
    }

    private func showToast(message: String, style: ToastStyle) {
        ToastView(message: message, style: style).show(in: view)
    }
}

// MARK: - UITableView

extension BlogViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.createdPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: BlogPostCell.identifier,
            for: indexPath
        ) as! BlogPostCell

        let post = viewModel.createdPosts[indexPath.row]

        cell.configure(with: BlogPost(
            userId: post.userId,
            id: post.id,
            title: post.title,
            body: post.body
        ))

        // subtle animation
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 10)

        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
            cell.transform = .identity
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.createdPosts[indexPath.row]
        openDetail(for: post)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] _, _, completion in

            guard let self else { return completion(false) }

            let post = self.viewModel.createdPosts[indexPath.row]

            Task {
                do {
                    try await self.viewModel.deletePost(post)
                    self.refreshUI(animated: true)
                    self.showToast(message: "Blog deleted", style: .success)
                    completion(true)
                } catch {
                    self.showToast(message: "Failed to delete", style: .error)
                    completion(false)
                }
            }
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }
}
