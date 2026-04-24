//
//  APIConstants.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
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

    static let jsonPlaceholderBaseURL: String = {
        if let url = ProcessInfo.processInfo.environment["BLOG_BASE_URL"] {
            return url
        }
        return "https://jsonplaceholder.typicode.com"
    }()

    static let dummyAuthBaseURL: String = {
        if let url = ProcessInfo.processInfo.environment["DUMMY_AUTH_BASE_URL"] {
            return url
        }
        return "https://dummyjson.com"
    }()
}
