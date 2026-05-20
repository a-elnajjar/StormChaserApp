//
//  Models .swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation

// MARK: - API Response Model (maps directly from .NET API)

struct WeatherObservation:Codable, Sendable {
    let source: String
    let location: String
    let temperature: Double?
    let windSpeed: String?
    let windDirection: String?
    let humidity: Double?
    let description: String?
    let observedAt: Date
}



struct ForecastPeriod:Codable, Sendable {
    let name: String
    let temperature: Double?
    let windSpeed: String?
    let windDirection: String?
    let description: String?
}



// MARK: - Domain Model

struct Weather:Codable, Sendable {
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
    nonisolated init(from obs: WeatherObservation) {
        source = obs.source
        location = obs.location
        temperature = obs.temperature ?? 0
        windSpeed = obs.windSpeed ?? "N/A"
        windDirection = obs.windDirection ?? "N/A"
        humidity = obs.humidity ?? 0
        description = obs.description ?? "No description"
        observedAt = obs.observedAt
    }
}



struct WeatherForecast:Codable, Sendable {
    let source: String
    let location: String
    let periods: [ForecastPeriod]
}


