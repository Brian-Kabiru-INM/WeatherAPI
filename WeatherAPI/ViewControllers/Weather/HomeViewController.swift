//
//  HomeViewController.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

final class HomeViewController: UIViewController {
    private let titleLabel = UILabel()
    private let cityTextField = TextField(placeholder: "Enter city (e.g. Nairobi)")
    private let fetchButton = PrimaryButton(title: "Get Weather")
    private let weatherCardView = WeatherCardView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let viewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureActions()
        bindViewModel()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground

        titleLabel.text = "Forecast Hub"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLayout() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, cityTextField, fetchButton, weatherCardView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureActions() {
        fetchButton.addTarget(self, action: #selector(fetchWeatherTapped), for: .touchUpInside)
        cityTextField.addTarget(self, action: #selector(fetchWeatherTapped), for: .editingDidEndOnExit)
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.render(state)
        }
    }

    @objc private func fetchWeatherTapped() {
        Task {
            await viewModel.fetchWeather(city: cityTextField.text ?? "")
        }
    }

    private func render(_ state: WeatherViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            activityIndicator.startAnimating()
            fetchButton.setLoading(true)
        case .loaded(let model):
            activityIndicator.stopAnimating()
            fetchButton.setLoading(false)
            weatherCardView.render(with: model)
            showToast(message: "Weather loaded successfully", style: .success)
        case .failed(let message):
            activityIndicator.stopAnimating()
            fetchButton.setLoading(false)
            showToast(message: message, style: .error)
        }
    }

    private func showToast(message: String, style: ToastStyle) {
        let toast = ToastView(message: message, style: style)
        toast.show(in: view)
    }
}
