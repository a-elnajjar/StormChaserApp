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
	@MainActor private static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

	@MainActor private static let iso8601WithoutFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

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
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let rawValue = try container.decode(String.self)

                if let date = Self.iso8601WithFractionalSeconds.date(from: rawValue) {
                    return date
                }

                if let date = Self.iso8601WithoutFractionalSeconds.date(from: rawValue) {
                    return date
                }

                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unsupported ISO8601 date format: \(rawValue)"
                )
            }
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch let error as NetworkError {
            throw error
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.networkError
        }
    }
}
