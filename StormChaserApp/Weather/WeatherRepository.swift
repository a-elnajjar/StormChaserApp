//
//  WeatherRepository.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation

// MARK: - Weather Repository Protocol

protocol WeatherRepositoryProtocol: Sendable {
    func getWeather(latitude: Double, longitude: Double) async throws -> Weather
    func getForecast(latitude: Double, longitude: Double) async throws -> [WeatherForecast]
}

// MARK: - Weather Repository Implementation
 
final class WeatherRepository: WeatherRepositoryProtocol {

	
	private let networkClient: NetworkClient
	
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	func getWeather(latitude: Double, longitude: Double) async throws -> Weather {
		guard let url = URL(string: "https://localhost:7238/api/weather/current?lat=\(latitude)&lon=\(longitude)") else {
			throw NetworkError.invalidURL
		}
		let observations: [WeatherObservation] = try await networkClient.get(url: url)
		guard let observation = observations.first else {
			throw NetworkError.invalidResponse
		}
		return Weather(from: observation)
	}
	
	func getForecast(latitude: Double, longitude: Double) async throws -> [WeatherForecast] {
		guard let url = URL(string: "https://localhost:7238/api/weather/forecast?lat=\(latitude)&lon=\(longitude)") else {
			throw NetworkError.invalidURL
		}
		
		return try await networkClient.get(url: url)
	}
}
