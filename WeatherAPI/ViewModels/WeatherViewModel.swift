//
//  WeatherViewModel.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

enum WeatherViewState {
    case idle
    case loading
    case loaded(WeatherDisplayModel)
    case failed(String)
}

@MainActor
final class WeatherViewModel {
    var onStateChanged: ((WeatherViewState) -> Void)?

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }

    convenience init() {
        self.init(weatherService: WeatherService())
    }

    func fetchWeather(city: String) async {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedCity.isEmpty else {
            onStateChanged?(.failed("Enter a city name first."))
            return
        }

        onStateChanged?(.loading)

        do {
            let weather = try await weatherService.fetchWeather(for: trimmedCity)
            let model = WeatherDisplayModel(
                city: weather.name,
                temperatureText: "\(Int(weather.main.temp.rounded()))°C",
                descriptionText: weather.conditionDescription,
                feelsLikeText: "Feels like \(Int(weather.main.feelsLike.rounded()))°C",
                humidityText: "Humidity: \(Int(weather.main.humidity))%",
                windSpeedText: "Wind: \(String(format: "%.1f", weather.wind.speed)) m/s",
                iconURL: URL(string: "\(APIConstants.iconBaseURL)\(weather.conditionIconCode)@2x.png")
            )
            onStateChanged?(.loaded(model))
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "Something went wrong."
            onStateChanged?(.failed(message))
        }
    }
}
