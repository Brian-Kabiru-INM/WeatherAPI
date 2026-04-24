//
//  NetworkError.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case cityNotFound
    case serverError
    case decodingFailed
    case networkUnavailable
    case resourceNotFound
    case invalidCredentials
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
        case .resourceNotFound:
            return "Requested resource was not found."
        case .invalidCredentials:
            return "Invalid username or password."
        case .unknown:
            return "Something went wrong."
        }
    }
}
