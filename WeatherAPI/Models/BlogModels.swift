//
//  BlogModels.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

struct BlogPost: Codable {
    let userId: Int
    let id: Int?
    let title: String
    let body: String
}

struct BlogComment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

struct BlogUser: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

struct CreatePostRequest: Encodable {
    let userId: Int
    let title: String
    let body: String
}

struct UpdatePostRequest: Encodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct PatchPostRequest: Encodable {
    let title: String?
    let body: String?
}
