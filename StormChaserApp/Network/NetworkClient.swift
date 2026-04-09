//
//  NetworkClient.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation

// MARK: Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .decodingError:
            return "Failed to decode response"
        case .networkError:
            return "Network error"
        case .unknown:
            return "Unknown error"
        }
    }
}

// MARK: Generic Network Client Actor

actor NetworkClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<T: Decodable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidResponse
            }
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			let decoded = try decoder.decode(T.self, from: data)
			return decoded
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.networkError
        }
    }
}
