import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case cityNotFound
    case serverError
    case decodingFailed
    case networkUnavailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Request URL is invalid."
        case .invalidResponse:
            return "Invalid response from server."
        case .cityNotFound:
            return "City not found. Please try another name."
        case .serverError:
            return "Server error occurred. Please try again later."
        case .decodingFailed:
            return "Could not parse weather data."
        case .networkUnavailable:
            return "No internet connection."
        case .unknown:
            return "Something went wrong."
        }
    }
}
