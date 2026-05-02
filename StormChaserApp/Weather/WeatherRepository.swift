//
//  WeatherRepository.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation

// MARK: - Weather Repository Protocol

protocol WeatherRepositoryProtocol: Sendable {
    func getWeather(country:String,latitude: Double, longitude: Double) async throws -> Weather
    func getForecast(country:String,latitude: Double, longitude: Double) async throws -> WeatherForecast
}

// MARK: - Weather Repository Implementation
 
actor WeatherRepository: WeatherRepositoryProtocol {
	private let baseURL: String = AppConfig.WeatherAPI.baseURL
	private let networkClient: NetworkClient
	
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	func getWeather(country:String, latitude: Double, longitude: Double) async throws -> Weather {
	
		guard let url = URL(string: "\(baseURL)/current?country=\(country)&lat=\(latitude)&lon=\(longitude)") else {
			throw NetworkError.invalidURL
		}
		var request = URLRequest(url: url)
		request.cachePolicy = AppConfig.CachePolicies.currentWeather
		let observation: WeatherObservation = try await fetchWithOfflineFallback(request: request)
		return Weather(from: observation)
	}

	func getForecast(country:String,latitude: Double, longitude: Double) async throws -> WeatherForecast {
		guard let url = URL(string: "\(baseURL)/forecast?country=\(country)&lat=\(latitude)&lon=\(longitude)") else {
			throw NetworkError.invalidURL
		}

		var request = URLRequest(url: url)
		request.cachePolicy = AppConfig.CachePolicies.forecast
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
