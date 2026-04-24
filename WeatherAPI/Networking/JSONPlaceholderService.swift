//
//  JSONPlaceholderService.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import Foundation

protocol JSONPlaceholderServiceProtocol {
    func fetchPosts() async throws -> [BlogPost]
    func fetchPost(id: Int) async throws -> BlogPost
    func createPost(_ request: CreatePostRequest) async throws -> BlogPost
    func updatePost(id: Int, request: UpdatePostRequest) async throws -> BlogPost
    func patchPost(id: Int, request: PatchPostRequest) async throws -> BlogPost
    func deletePost(id: Int) async throws
    func fetchPosts(userId: Int) async throws -> [BlogPost]
    func fetchCommentsForPost(id: Int) async throws -> [BlogComment]
    func fetchComments() async throws -> [BlogComment]
    func fetchComments(postId: Int) async throws -> [BlogComment]
    func fetchUsers() async throws -> [BlogUser]
    func fetchUser(id: Int) async throws -> BlogUser
}

final class JSONPlaceholderService: JSONPlaceholderServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchPosts() async throws -> [BlogPost] {
        try await request(path: "/posts", method: "GET")
    }

    func fetchPost(id: Int) async throws -> BlogPost {
        try await request(path: "/posts/\(id)", method: "GET")
    }

    func createPost(_ requestPayload: CreatePostRequest) async throws -> BlogPost {
        try await request(path: "/posts", method: "POST", body: try JSONEncoder().encode(requestPayload))
    }

    func updatePost(id: Int, request requestPayload: UpdatePostRequest) async throws -> BlogPost {
        try await request(path: "/posts/\(id)", method: "PUT", body: try JSONEncoder().encode(requestPayload))
    }

    func patchPost(id: Int, request requestPayload: PatchPostRequest) async throws -> BlogPost {
        try await request(path: "/posts/\(id)", method: "PATCH", body: try JSONEncoder().encode(requestPayload))
    }

    func deletePost(id: Int) async throws {
        _ = try await request(path: "/posts/\(id)", method: "DELETE") as EmptyResponse
    }

    func fetchPosts(userId: Int) async throws -> [BlogPost] {
        try await request(path: "/posts", method: "GET", queryItems: [URLQueryItem(name: "userId", value: "\(userId)")])
    }

    func fetchCommentsForPost(id: Int) async throws -> [BlogComment] {
        try await request(path: "/posts/\(id)/comments", method: "GET")
    }

    func fetchComments() async throws -> [BlogComment] {
        try await request(path: "/comments", method: "GET")
    }

    func fetchComments(postId: Int) async throws -> [BlogComment] {
        try await request(path: "/comments", method: "GET", queryItems: [URLQueryItem(name: "postId", value: "\(postId)")])
    }

    func fetchUsers() async throws -> [BlogUser] {
        try await request(path: "/users", method: "GET")
    }

    func fetchUser(id: Int) async throws -> BlogUser {
        try await request(path: "/users/\(id)", method: "GET")
    }

    private func request<T: Decodable>(
        path: String,
        method: String,
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) async throws -> T {
        var components = URLComponents(string: APIConstants.jsonPlaceholderBaseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 404 {
                    throw NetworkError.resourceNotFound
                }
                if (500...599).contains(httpResponse.statusCode) {
                    throw NetworkError.serverError
                }
                throw NetworkError.invalidResponse
            }

            if T.self == EmptyResponse.self, data.isEmpty {
                return EmptyResponse() as! T
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed
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

private struct EmptyResponse: Decodable {
}
