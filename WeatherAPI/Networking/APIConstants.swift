import Foundation

enum APIConstants {
    // Load from environment variables or use fallbacks
    static let apiKey: String = {
        if let key = ProcessInfo.processInfo.environment["WEATHER_API_KEY"] {
            return key
        }
        return "" // Fallback (for testing)
    }()
    
    static let weatherBaseURL: String = {
        if let url = ProcessInfo.processInfo.environment["WEATHER_BASE_URL"] {
            return url + "/weather"
        }
        return "https://api.openweathermap.org/data/2.5/weather" // Fallback
    }()
    
    static let iconBaseURL: String = {
        if let url = ProcessInfo.processInfo.environment["ICON_BASE_URL"] {
            return url
        }
        return "https://openweathermap.org/img/wn/" // Fallback
    }()
}
