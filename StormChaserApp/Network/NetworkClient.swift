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

    init() {
        self.session = URLCacheProvider.createConfiguredSession()
    }

    init(session: URLSession) {
        self.session = session
    }

    func get<T: Decodable & Sendable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        return try await get(request: request)
    }

    func get<T: Decodable & Sendable>(request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom(Self.DateDecodingStrategy)
            return try decoder.decode(T.self, from: data)
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.networkError
        }
    }
    

    private static func DateDecodingStrategy(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        let formatOptions: [ISO8601DateFormatter.Options] = [
            [.withInternetDateTime, .withFractionalSeconds],
            [.withInternetDateTime]
        ]

        for options in formatOptions {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = options
            if let date = formatter.date(from: rawValue) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unsupported ISO8601 date format: \(rawValue)"
        )
    }
}
