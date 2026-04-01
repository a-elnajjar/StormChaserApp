//
//  WeatherRepository.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation

// MARK: - Weather Repository Protocol

protocol WeatherRepositoryProtocol {
    func getWeather(latitude: Double, longitude: Double) async throws -> Weather
}

// MARK: - Weather Repository Implementation

class WeatherRepository: WeatherRepositoryProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getWeather(latitude: Double, longitude: Double) async throws -> Weather {
        guard let pointsURL = URL(string: "https://api.weather.gov/points/\(latitude),\(longitude)") else {
            throw NetworkError.invalidURL
        }
        let pointsData: PointData = try await networkClient.get(url: pointsURL)

        guard let forecastURL = URL(string: pointsData.properties.forecast) else {
            throw NetworkError.invalidURL
        }

        let forecastData: ForecastData = try await networkClient.get(url: forecastURL)

        guard let current = forecastData.properties.periods.first else {
            throw NetworkError.decodingError
        }

        let forecast = forecastData.properties.periods.prefix(7).map { period in
            ForecastPeriod(
                name: period.name,
                temperature: period.temperature ?? 0,
                windSpeed: period.windSpeed ?? "N/A",
                description: period.shortForecast
            )
        }

        return Weather(
            temperature: current.temperature ?? 0,
            windSpeed: current.windSpeed ?? "N/A",
            windDirection: current.windDirection ?? "N/A",
            humidity: current.relativeHumidity?.value ?? 0,
            description: current.shortForecast,
            forecast: forecast
        )
    }
}
