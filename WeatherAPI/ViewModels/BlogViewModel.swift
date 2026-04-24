//
//  BlogViewModel.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

@MainActor
final class BlogViewModel {
    struct CreatedPost: Equatable {
        let id: Int
        var userId: Int
        var title: String
        var body: String
    }

    enum ValidationError: LocalizedError {
        case invalidPostId
        case invalidUserId
        case missingTitle
        case missingBody

        var errorDescription: String? {
            switch self {
            case .invalidPostId:
                return "Post ID must be a positive number."
            case .invalidUserId:
                return "User ID must be a positive number."
            case .missingTitle:
                return "Post title is required."
            case .missingBody:
                return "Post body is required."
            }
        }
    }

    private(set) var createdPosts: [CreatedPost] = []

    private let blogService: JSONPlaceholderServiceProtocol

    init(blogService: JSONPlaceholderServiceProtocol) {
        self.blogService = blogService
    }

    convenience init() {
        self.init(blogService: JSONPlaceholderService())
    }

    func createPost(postIdText: String, userIdText: String, title: String, body: String) async throws -> CreatedPost {
        let postId = try parsePositiveInt(postIdText, error: .invalidPostId)
        let userId = try parsePositiveInt(userIdText, error: .invalidUserId)
        let cleanedTitle = try validatedText(title, error: .missingTitle)
        let cleanedBody = try validatedText(body, error: .missingBody)

        let request = CreatePostRequest(userId: userId, title: cleanedTitle, body: cleanedBody)
        _ = try await blogService.createPost(request)

        let created = CreatedPost(id: postId, userId: userId, title: cleanedTitle, body: cleanedBody)
        createdPosts.insert(created, at: 0)
        return created
    }

    func updatePost(_ post: CreatedPost, userIdText: String, title: String, body: String) async throws -> CreatedPost {
        let userId = try parsePositiveInt(userIdText, error: .invalidUserId)
        let cleanedTitle = try validatedText(title, error: .missingTitle)
        let cleanedBody = try validatedText(body, error: .missingBody)

        let request = UpdatePostRequest(userId: userId, id: post.id, title: cleanedTitle, body: cleanedBody)
        _ = try await blogService.updatePost(id: post.id, request: request)

        let updated = CreatedPost(id: post.id, userId: userId, title: cleanedTitle, body: cleanedBody)
        if let index = createdPosts.firstIndex(where: { $0.id == post.id }) {
            createdPosts[index] = updated
        }

        return updated
    }

    func deletePost(_ post: CreatedPost) async throws {
        try await blogService.deletePost(id: post.id)
        createdPosts.removeAll { $0.id == post.id }
    }

    private func parsePositiveInt(_ text: String, error: ValidationError) throws -> Int {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Int(cleaned), value > 0 else {
            throw error
        }
        return value
    }

    private func validatedText(_ text: String, error: ValidationError) throws -> String {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else {
            throw error
        }
        return cleaned
    }
}
