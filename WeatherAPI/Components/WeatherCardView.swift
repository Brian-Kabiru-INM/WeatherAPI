import UIKit

final class WeatherCardView: UIView {
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let detailsLabel = UILabel()
    private let iconImageView = UIImageView()
    private var iconTask: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with model: WeatherDisplayModel) {
        cityLabel.text = model.city
        temperatureLabel.text = model.temperatureText
        descriptionLabel.text = model.descriptionText
        detailsLabel.text = "\(model.feelsLikeText) · \(model.humidityText) · \(model.windSpeedText)"
        loadIcon(from: model.iconURL)
        isHidden = false
    }

    private func setup() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        cityLabel.font = .boldSystemFont(ofSize: 24)
        cityLabel.textColor = .label

        temperatureLabel.font = .systemFont(ofSize: 42, weight: .bold)
        temperatureLabel.textColor = .label

        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = .secondaryLabel

        detailsLabel.font = .systemFont(ofSize: 14)
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.numberOfLines = 0

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .label

        let headerStack = UIStackView(arrangedSubviews: [cityLabel, iconImageView])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing

        iconImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        let stack = UIStackView(arrangedSubviews: [headerStack, temperatureLabel, descriptionLabel, detailsLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])

        isHidden = true
    }

    private func loadIcon(from url: URL?) {
        iconTask?.cancel()
        iconImageView.image = UIImage(systemName: "cloud.sun")

        guard let url else { return }

        iconTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
        iconTask?.resume()
    }
}
