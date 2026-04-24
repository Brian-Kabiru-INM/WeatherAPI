//
//  AuthModels.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

struct DummyLoginRequest: Encodable {
    let username: String
    let password: String
    let expiresInMins: Int
}

struct DummyLoginResponse: Decodable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let image: String
    let accessToken: String
    let refreshToken: String
}

struct DummyAuthUser: Decodable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let image: String
}
