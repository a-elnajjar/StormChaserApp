//
//  Models .swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation




// MARK: - API Response Model (maps directly from .NET API)

struct WeatherObservation: Codable, Sendable {
	let source: String
	let location: String
	let temperature: Double?
	let windSpeed: String?
	let windDirection: String?
	let humidity: Double?
	let description: String?
	let observedAt: Date
	let forecasts: [ForecastPeriod]
}

struct ForecastPeriod: Codable, Sendable {
	let name: String
	let temperature: Double?
	let windSpeed: String?
	let windDirection: String?
	let description: String?
}

// MARK: - Domain Model

struct Weather: Sendable {
	let source: String
	let location: String
	let temperature: Double
	let windSpeed: String
	let windDirection: String
	let humidity: Double
	let description: String
	let observedAt: Date
	let forecast: [ForecastPeriod]

	init(from obs: WeatherObservation) {
		self.source       = obs.source
		self.location     = obs.location
		self.temperature  = obs.temperature ?? 0
		self.windSpeed    = obs.windSpeed ?? "N/A"
		self.windDirection = obs.windDirection ?? "N/A"
		self.humidity     = obs.humidity ?? 0
		self.description  = obs.description ?? "No description"
		self.observedAt   = obs.observedAt
		self.forecast     = obs.forecasts
	}
}
