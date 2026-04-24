//
//  AuthSessionStore.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

final class AuthSessionStore {
    static let shared = AuthSessionStore()

    private enum Keys {
        static let accessToken = "auth.accessToken"
        static let refreshToken = "auth.refreshToken"
        static let username = "auth.username"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var accessToken: String? {
        defaults.string(forKey: Keys.accessToken)
    }

    var refreshToken: String? {
        defaults.string(forKey: Keys.refreshToken)
    }

    var username: String? {
        defaults.string(forKey: Keys.username)
    }

    func save(accessToken: String, refreshToken: String, username: String) {
        defaults.set(accessToken, forKey: Keys.accessToken)
        defaults.set(refreshToken, forKey: Keys.refreshToken)
        defaults.set(username, forKey: Keys.username)
    }

    func clear() {
        defaults.removeObject(forKey: Keys.accessToken)
        defaults.removeObject(forKey: Keys.refreshToken)
        defaults.removeObject(forKey: Keys.username)
    }
}
