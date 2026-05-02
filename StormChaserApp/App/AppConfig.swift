//
//  AppConfig.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-02.
//

import Foundation

enum AppConfig {
    // MARK: - Locations

    enum Locations {
        // New York City used as fallback; weather.gov only covers the US
        static let newYorkCityLatitude: Double = 40.7128
        static let newYorkCityLongitude: Double = -74.0060
    }

    // MARK: - Debug Cities

    struct DebugCity: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let latitude: Double
        let longitude: Double
		let countryCode:String
    }

    enum DebugCities {
        static let all: [DebugCity] = [
			DebugCity(name: "New York, NY", latitude: 40.7128, longitude: -74.0060, countryCode: "US"),
			DebugCity(name: "Los Angeles, CA", latitude: 34.0522, longitude: -118.2437, countryCode: "US"),
			DebugCity(name: "Chicago, IL", latitude: 41.8781, longitude: -87.6298, countryCode: "US"),
			DebugCity(name: "Houston, TX", latitude: 29.7604, longitude: -95.3698, countryCode: "US"),
			DebugCity(name: "Miami, FL", latitude: 25.7617, longitude: -80.1918, countryCode: "US"),
			DebugCity(name: "Denver, CO", latitude: 39.7392, longitude: -104.9903, countryCode: "US"),
			DebugCity(name: "Oklahoma City, OK", latitude: 35.4676, longitude: -97.5164, countryCode: "US"),
			DebugCity(name: "Kansas City, MO", latitude: 39.0997, longitude: -94.5786, countryCode: "US"),

			// Canada
			DebugCity(name: "Toronto, ON", latitude: 43.6532, longitude: -79.3832, countryCode: "CA"),
			DebugCity(name: "Montreal, QC", latitude: 45.5019, longitude: -73.5674, countryCode: "CA"),
			DebugCity(name: "Vancouver, BC", latitude: 49.2827, longitude: -123.1207, countryCode: "CA"),
			DebugCity(name: "Calgary, AB", latitude: 51.0447, longitude: -114.0719, countryCode: "CA"),
			DebugCity(name: "Edmonton, AB", latitude: 53.5461, longitude: -113.4938, countryCode: "CA"),
			DebugCity(name: "Ottawa, ON", latitude: 45.4215, longitude: -75.6972, countryCode: "CA"),
			DebugCity(name: "Winnipeg, MB", latitude: 49.8951, longitude: -97.1384, countryCode: "CA"),
			DebugCity(name: "Halifax, NS", latitude: 44.6488, longitude: -63.5752, countryCode: "CA"),
			DebugCity(name: "London, ON", latitude: 42.9849, longitude: -81.2453, countryCode: "CA"),
			DebugCity(name: "Quebec City, QC", latitude: 46.8139, longitude: -71.2080, countryCode: "CA"),
        ]
    }

    // MARK: - Storm Types

    enum StormTypes {
        static let all = ["Thunderstorm", "Tornado", "Hail", "Lightning", "Flooding", "Other"]
    }
        
    enum WeatherAPI {
        #if DEBUG
        nonisolated static let baseURL = "http://localhost:5171/api/weather"
		//static let baseURL = "http://localhost:8080/api/v1/weather"
        #else
        nonisolated static let baseURL = "https://your-production-server.com/api/weather"
        #endif
    }

    // MARK: - Cache Policies

    enum CachePolicies {
        nonisolated static let currentWeather: URLRequest.CachePolicy = .useProtocolCachePolicy
        nonisolated static let forecast: URLRequest.CachePolicy = .returnCacheDataElseLoad
        nonisolated static let `default`: URLRequest.CachePolicy = .useProtocolCachePolicy
    }
}
