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
    }

    enum DebugCities {
        static let all: [DebugCity] = [
            DebugCity(name: "New York, NY", latitude: 40.7128, longitude: -74.0060),
            DebugCity(name: "Los Angeles, CA", latitude: 34.0522, longitude: -118.2437),
            DebugCity(name: "Chicago, IL", latitude: 41.8781, longitude: -87.6298),
            DebugCity(name: "Houston, TX", latitude: 29.7604, longitude: -95.3698),
            DebugCity(name: "Miami, FL", latitude: 25.7617, longitude: -80.1918),
            DebugCity(name: "Denver, CO", latitude: 39.7392, longitude: -104.9903),
            DebugCity(name: "Oklahoma City, OK", latitude: 35.4676, longitude: -97.5164),
            DebugCity(name: "Kansas City, MO", latitude: 39.0997, longitude: -94.5786),
        ]
    }

    // MARK: - Storm Types

    enum StormTypes {
        static let all = ["Thunderstorm", "Tornado", "Hail", "Lightning", "Flooding", "Other"]
    }
        
    enum WeatherAPI {
        #if DEBUG
        static let baseURL = "https://localhost:7238/api/weather"
        #else
        static let baseURL = "https://your-production-server.com/api/weather"
        #endif
    }
}
