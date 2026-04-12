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
    case success(Weather, [WeatherForecast])
    case error(String)
}

// MARK: Weather ViewModel

@Observable
@MainActor
class WeatherViewModel {
	
    var state: WeatherState = .idle
	
	 var current: [Weather] = []
	 var forecast: [WeatherForecast] = []

    private let weatherRepo: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        weatherRepo = repository
    }

    func fetchWeather(latitude: Double, longitude: Double) async {
		state = .loading
	
        do {
			async let current  = weatherRepo.getWeather(latitude: latitude, longitude: longitude)
			async let forecast = weatherRepo.getForecast(latitude: latitude, longitude: longitude)
			state = .success(try await current, try await forecast)
        } catch let error as NetworkError {
            self.state = .error(error.errorDescription ?? "Unknown error")
        } catch {
            state = .error("Failed to fetch weather")
        }
    }
}
