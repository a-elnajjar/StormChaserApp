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

    // MARK: - Storm Types

    enum StormTypes {
        static let all = ["Thunderstorm", "Tornado", "Hail", "Lightning", "Flooding", "Other"]
    }
}
