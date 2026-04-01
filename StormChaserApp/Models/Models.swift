//
//  Models .swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation

// MARK: - Weather Models

struct PointData: Codable, Sendable {
    let properties: PointProperties
}

struct PointProperties: Codable, Sendable {
    let forecast: String
}

struct ForecastData: Codable, Sendable {
    let properties: ForecastProperties
}

struct ForecastProperties: Codable, Sendable {
    let periods: [Period]
}

struct Period: Codable, Sendable {
    let name: String
    let temperature: Double?
    let windSpeed: String?
    let windDirection: String?
    let relativeHumidity: QuantitativeValue?
    let shortForecast: String
}

struct QuantitativeValue: Codable, Sendable {
    let value: Double?
}

// MARK: Domain Model

struct Weather: Sendable {
    let temperature: Double
    let windSpeed: String
    let windDirection: String
    let humidity: Double
    let description: String
    let forecast: [ForecastPeriod]
}

struct ForecastPeriod: Sendable {
    let name: String
    let temperature: Double
    let windSpeed: String
    let description: String
}
