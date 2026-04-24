//
//  ProfileLoginViewController.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

@MainActor
final class ProfileLoginViewController: UIViewController {
    private let logoImageView = UIImageView()
    private let headingLabel = UILabel()

    private let usernameField = TextField(placeholder: "Enter Username")
    private let passwordField = TextField(placeholder: "Enter Password")

    private let forgotPasswordButton = UIButton(type: .system)
    private let loginButton = PrimaryButton(title: "Login")
    private let faceIDButton = UIButton(type: .system)

    private let loginStack = UIStackView()

    private let loggedInContainer = UIStackView()
    private let profileTitleLabel = UILabel()
    private let profileSubtitleLabel = UILabel()
    private let logoutButton = PrimaryButton(title: "Logout")

    private let privacyLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let authService: DummyAuthServiceProtocol
    private let sessionStore: AuthSessionStore

    init(
        authService: DummyAuthServiceProtocol,
        sessionStore: AuthSessionStore
    ) {
        self.authService = authService
        self.sessionStore = sessionStore
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        let store = AuthSessionStore.shared
        let service = DummyAuthService(sessionStore: store)
        self.init(authService: service, sessionStore: store)
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
        restoreSessionIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func configureView() {
        view.backgroundColor = .systemBackground

        logoImageView.image = UIImage(named: "Logo")
        logoImageView.contentMode = .scaleAspectFit
        //logoImageView.contentHorizontalAlignment = .right
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        headingLabel.text = "Thank you for choosing\nI&M Bank Personal Banking"
        headingLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        headingLabel.textColor = .label
        headingLabel.numberOfLines = 0

        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.returnKeyType = .next

        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done

        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .light)
        forgotPasswordButton.setTitleColor(.systemTeal, for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .right

        faceIDButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        faceIDButton.tintColor = .systemPink
        faceIDButton.backgroundColor = .white
        faceIDButton.layer.cornerRadius = 24
        faceIDButton.layer.borderWidth = 1
        faceIDButton.layer.borderColor = UIColor.systemGray5.cgColor
        faceIDButton.translatesAutoresizingMaskIntoConstraints = false
        faceIDButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        faceIDButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        profileTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        profileTitleLabel.textColor = .label
        profileTitleLabel.textAlignment = .center

        profileSubtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        profileSubtitleLabel.textColor = .secondaryLabel
        profileSubtitleLabel.numberOfLines = 0
        profileSubtitleLabel.textAlignment = .center

        loggedInContainer.axis = .vertical
        loggedInContainer.spacing = 14
        loggedInContainer.addArrangedSubview(profileTitleLabel)
        loggedInContainer.addArrangedSubview(profileSubtitleLabel)
        loggedInContainer.addArrangedSubview(logoutButton)
        loggedInContainer.isHidden = true

        privacyLabel.text = "At I&M Bank, we are On Your Side and we value your data privacy.\nRead our Privacy Notice."
        let privacyText = privacyLabel.text ?? ""
        let attributedString = NSMutableAttributedString(string: privacyText)
        if let range = privacyText.range(of: "Read our Privacy Notice") {
            let nsRange = NSRange(range, in: privacyText)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "CyanGreen") ?? .systemCyan, range: nsRange)
        }
        privacyLabel.attributedText = attributedString
        privacyLabel.textColor = .secondaryLabel
        privacyLabel.font = .systemFont(ofSize: 10, weight: .light)
        privacyLabel.numberOfLines = 2
        privacyLabel.textAlignment = .center

        activityIndicator.hidesWhenStopped = true

        loginStack.axis = .vertical
        loginStack.spacing = 14
        loginStack.addArrangedSubview(headingLabel)
        loginStack.addArrangedSubview(usernameField)
        loginStack.addArrangedSubview(passwordField)
        loginStack.addArrangedSubview(forgotPasswordButton)

        let buttonRow = UIStackView(arrangedSubviews: [loginButton, faceIDButton])
        buttonRow.axis = .horizontal
        buttonRow.spacing = 12
        buttonRow.alignment = .center
        loginStack.addArrangedSubview(buttonRow)

        view.addSubview(logoImageView)
        view.addSubview(loginStack)
        view.addSubview(loggedInContainer)
        view.addSubview(activityIndicator)
        view.addSubview(privacyLabel)

        loginStack.translatesAutoresizingMaskIntoConstraints = false
        loggedInContainer.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            logoImageView.widthAnchor.constraint(equalToConstant: 350),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),

            loginStack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            loginStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            loggedInContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            loggedInContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loggedInContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loginStack.bottomAnchor, constant: 16),

            privacyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            privacyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            privacyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func configureActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotTapped), for: .touchUpInside)
        faceIDButton.addTarget(self, action: #selector(faceIDTapped), for: .touchUpInside)
    }

    private func restoreSessionIfNeeded() {
        guard let token = sessionStore.accessToken else {
            showLoggedOutState()
            return
        }

        Task {
            setLoading(true)
            do {
                let user = try await authService.currentUser(accessToken: token)
                showLoggedInState(user)
            } catch {
                sessionStore.clear()
                showLoggedOutState()
            }
            setLoading(false)
        }
    }

    @objc private func loginTapped() {
        let username = (usernameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password = (passwordField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !username.isEmpty, !password.isEmpty else {
            showToast(message: "Enter username and password.", style: .error)
            return
        }

        Task {
            setLoading(true)
            do {
                let response = try await authService.login(username: username, password: password)
                sessionStore.save(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    username: response.username
                )

                let user = DummyAuthUser(
                    id: response.id,
                    username: response.username,
                    email: response.email,
                    firstName: response.firstName,
                    lastName: response.lastName,
                    image: response.image
                )
                showLoggedInState(user)
                showToast(message: "Login successful.", style: .success)
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? "Login failed."
                showToast(message: message, style: .error)
            }
            setLoading(false)
        }
    }

    @objc private func logoutTapped() {
        Task {
            setLoading(true)
            await authService.logout()
            showLoggedOutState()
            setLoading(false)
            showToast(message: "Logged out.", style: .success)
        }
    }

    @objc private func forgotTapped() {
        showToast(message: "Use a DummyJSON user password.", style: .success)
    }

    @objc private func faceIDTapped() {
        showToast(message: "Face ID demo only on this screen.", style: .success)
    }

    private func showLoggedInState(_ user: DummyAuthUser) {
        loginStack.isHidden = true
        loggedInContainer.isHidden = false

        profileTitleLabel.text = "Welcome, \(user.firstName)"
        profileSubtitleLabel.text = "@\(user.username)\n\(user.email)"
    }

    private func showLoggedOutState() {
        loginStack.isHidden = false
        loggedInContainer.isHidden = true
        passwordField.text = ""
    }

    private func setLoading(_ isLoading: Bool) {
        loginButton.setLoading(isLoading)
        logoutButton.setLoading(isLoading)

        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    private func showToast(message: String, style: ToastStyle) {
        ToastView(message: message, style: style).show(in: view)
    }
}
