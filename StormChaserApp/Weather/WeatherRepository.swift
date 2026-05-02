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
 
final class WeatherRepository: WeatherRepositoryProtocol, @unchecked Sendable {
	private let baseURL: String = AppConfig.WeatherAPI.baseURL
	private let networkClient: NetworkClient
	
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	func getWeather(country:String, latitude: Double, longitude: Double) async throws -> Weather {
	
		guard let url = URL(string: "\(baseURL)/current?country=\(country)&lat=\(latitude)&lon=\(longitude)") else {
			throw NetworkError.invalidURL
		}
		let observation: WeatherObservation = try await networkClient.get(url: url)
		return Weather(from: observation)
	}
	
	func getForecast(country:String,latitude: Double, longitude: Double) async throws -> WeatherForecast {
		guard let url = URL(string: "\(baseURL)/forecast?country=\(country)&lat=\(latitude)&lon=\(longitude)") else {
			throw NetworkError.invalidURL
		}
		
		return try await networkClient.get(url: url)
	}
}
