//
//  PostRepository.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-05-05.
//

import Foundation


// MARK: - post Repository Protocol

protocol PostRepositoryProtocol: Sendable {
	func getPost() async throws -> [post]

}



actor PostRepository: PostRepositoryProtocol {

	
	private let networkClient: NetworkClient
	
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	
	func getPost() async throws -> [post] {
		guard let url = URL(string: "https://dummyjson.com/posts") else {
			throw NetworkError.invalidURL
		}
		var request = URLRequest(url: url)
		request.cachePolicy = AppConfig.CachePolicies.posts
		return try await fetchWithOfflineFallback(request: request)
	}
	
	
	private func fetchWithOfflineFallback<T: Decodable & Sendable>(request: URLRequest) async throws -> T {
		do {
			return try await networkClient.get(request: request)
		} catch {
			var cached = request
			cached.cachePolicy = .returnCacheDataDontLoad
			return try await networkClient.get(request: cached)
		}
	}
	
}
