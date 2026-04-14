import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResponse
}

final class WeatherService: WeatherServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }

        let urlString = "\(APIConstants.weatherBaseURL)?q=\(encodedCity)&appid=\(APIConstants.apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    return try JSONDecoder().decode(WeatherResponse.self, from: data)
                } catch {
                    throw NetworkError.decodingFailed
                }
            case 404:
                throw NetworkError.cityNotFound
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.invalidResponse
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain {
                throw NetworkError.networkUnavailable
            }
            throw NetworkError.unknown
        }
    }
}
