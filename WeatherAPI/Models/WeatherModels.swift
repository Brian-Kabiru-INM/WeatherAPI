import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let weather: [WeatherCondition]
    let main: MainWeather
    let wind: Wind

    var conditionDescription: String {
        weather.first?.description.capitalized ?? "Unknown"
    }

    var conditionIconCode: String {
        weather.first?.icon ?? "01d"
    }
}

struct WeatherCondition: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Decodable {
    let temp: Double
    let feelsLike: Double
    let humidity: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
    }
}

struct Wind: Decodable {
    let speed: Double
}

struct WeatherDisplayModel {
    let city: String
    let temperatureText: String
    let descriptionText: String
    let feelsLikeText: String
    let humidityText: String
    let windSpeedText: String
    let iconURL: URL?
}
