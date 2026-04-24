//
//  DummyAuthService.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

protocol DummyAuthServiceProtocol {
    func login(username: String, password: String) async throws -> DummyLoginResponse
    func currentUser(accessToken: String) async throws -> DummyAuthUser
    func logout() async
}

final class DummyAuthService: DummyAuthServiceProtocol {
    private let session: URLSession
    private let sessionStore: AuthSessionStore

    init(session: URLSession = .shared, sessionStore: AuthSessionStore = .shared) {
        self.session = session
        self.sessionStore = sessionStore
    }

    func login(username: String, password: String) async throws -> DummyLoginResponse {
        guard let url = URL(string: APIConstants.dummyAuthBaseURL + "/auth/login") else {
            throw NetworkError.invalidURL
        }

        let requestBody = DummyLoginRequest(
            username: username,
            password: password,
            expiresInMins: 60
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(DummyLoginResponse.self, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
        case 400, 401:
            throw NetworkError.invalidCredentials
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }

    func currentUser(accessToken: String) async throws -> DummyAuthUser {
        guard let url = URL(string: APIConstants.dummyAuthBaseURL + "/auth/me") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            do {
                return try JSONDecoder().decode(DummyAuthUser.self, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
        case 401:
            throw NetworkError.invalidCredentials
        default:
            throw NetworkError.invalidResponse
        }
    }

    func logout() async {
        sessionStore.clear()
    }
}
