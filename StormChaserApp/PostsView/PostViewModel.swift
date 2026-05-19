//
//  PostViewModel.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-05-05.
//

import Foundation

enum PostState {
	case idle
	case loading
	case success([post])
	case error(String)
}

@Observable
@MainActor
class PostViewModel {
	var state: PostState = .idle
	
	private let postRepo: PostRepositoryProtocol

	init(repository: PostRepositoryProtocol) {
		postRepo = repository
	}
	
	
	
	func fetchWeather(country: String, latitude: Double, longitude: Double) async {

		do {
			async let posts = postRepo.getPost()
			state = try .success(await posts)
		} catch let error as NetworkError {
			self.state = .error(error.errorDescription ?? "Unknown error")
		} catch {
			state = .error("Failed to fetch posts")
		}
	}
	
}
