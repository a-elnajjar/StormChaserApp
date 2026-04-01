//
//  WeatherViewModel.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation
import Observation

// MARK: Weather State

enum WeatherState {
    case idle
    case loading
    case success(Weather)
    case error(String)
}

// MARK: Weather ViewModel

@Observable
@MainActor
class WeatherViewModel {
    var state: WeatherState = .idle

    private let weatherRepo: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        weatherRepo = repository
    }

    func fetchWeather(latitude: Double, longitude: Double) async {
        state = .loading

        do {
            let weather = try await weatherRepo.getWeather(latitude: latitude, longitude: longitude)
            state = .success(weather)
        } catch let error as NetworkError {
            self.state = .error(error.errorDescription ?? "Unknown error")
        } catch {
            state = .error("Failed to fetch weather")
        }
    }
}
