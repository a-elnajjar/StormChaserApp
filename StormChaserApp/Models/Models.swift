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

struct Weather: Codable, Sendable {
	let source: String
	let location: String
	let temperature: Double
	let windSpeed: String
	let windDirection: String
	let humidity: Double
	let description: String
	let observedAt: Date

	init(
		source: String,
		location: String,
		temperature: Double,
		windSpeed: String,
		windDirection: String,
		humidity: Double,
		description: String,
		observedAt: Date
	) {
		self.source = source
		self.location = location
		self.temperature = temperature
		self.windSpeed = windSpeed
		self.windDirection = windDirection
		self.humidity = humidity
		self.description = description
		self.observedAt = observedAt
	}

	// separate init — no conflict with Codable
	init(from obs: WeatherObservation) {
		self.source        = obs.source
		self.location      = obs.location
		self.temperature   = obs.temperature ?? 0
		self.windSpeed     = obs.windSpeed ?? "N/A"
		self.windDirection = obs.windDirection ?? "N/A"
		self.humidity      = obs.humidity ?? 0
		self.description   = obs.description ?? "No description"
		self.observedAt    = obs.observedAt
	}

	// Codable init — must also be present when you define any init
	init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: CodingKeys.self)
		source        = try c.decode(String.self, forKey: .source)
		location      = try c.decode(String.self, forKey: .location)
		temperature   = try c.decodeIfPresent(Double.self, forKey: .temperature) ?? 0
		windSpeed     = try c.decodeIfPresent(String.self, forKey: .windSpeed) ?? "N/A"
		windDirection = try c.decodeIfPresent(String.self, forKey: .windDirection) ?? "N/A"
		humidity      = try c.decodeIfPresent(Double.self, forKey: .humidity) ?? 0
		description   = try c.decodeIfPresent(String.self, forKey: .description) ?? "No description"
		observedAt    = try c.decode(Date.self,   forKey: .observedAt)
	}
}



struct WeatherForecast: Codable, Sendable {
	let source: String
	let location: String
	let periods: [ForecastPeriod]
}
