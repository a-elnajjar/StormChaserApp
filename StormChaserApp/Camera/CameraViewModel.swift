//
//  CameraViewModel.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import CoreLocation
import Observation
import SwiftData
import SwiftUI

@Observable
@MainActor
final class CameraViewModel {
    var selectedImage: UIImage?
    var showCamera = false
    var showMetadataForm = false
    var isPreparingMetadata = false
    var stormType = AppConfig.StormTypes.all[0]
    var notes = ""
    var intensity = 2
    var duration = ""
    var weatherData: Weather?
    var currentLocation: (lat: Double, lon: Double)?
    var showSuccessAlert = false
    var alertMessage = ""

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository(networkClient: NetworkClient())) {
        self.weatherRepository = weatherRepository
    }

    func prepareMetadataForm(userLocation: CLLocationCoordinate2D?) async {
        isPreparingMetadata = true
        defer { isPreparingMetadata = false }

		if userLocation != nil {
            // weather.gov only covers the US, so NYC is used as the fixed location
            currentLocation = (AppConfig.Locations.newYorkCityLatitude, AppConfig.Locations.newYorkCityLongitude)
        }

        if let lat = currentLocation?.lat, let lon = currentLocation?.lon {
            weatherData = try? await weatherRepository.getWeather(latitude: lat, longitude: lon)
        }

        showMetadataForm = true
    }

    func saveStorm(photo: UIImage, modelContext: ModelContext) {
        let repository = StormRepository(modelContext: modelContext)
        let storm = Storm(
            photoData: photo.jpegData(compressionQuality: 0.8),
            temperature: weatherData?.temperature,
            humidity: weatherData?.humidity,
            windSpeed: weatherData?.windSpeed,
            weatherDescription: weatherData?.description,
            latitude: AppConfig.Locations.newYorkCityLatitude,
            longitude: AppConfig.Locations.newYorkCityLongitude,
            timestamp: Date(),
            notes: notes,
            stormType: stormType,
            intensity: intensity
        )

        Task {
            do {
                try await repository.addStorm(storm)
                alertMessage = "Storm saved successfully!\n\nType: \(stormType)\nLocation: \(String(format: "%.2f°, %.2f°", currentLocation?.lat ?? 0, currentLocation?.lon ?? 0))"
                showSuccessAlert = true
                resetForm()
            } catch {
                alertMessage = "Failed to save storm: \(error.localizedDescription)"
                showSuccessAlert = true
            }
        }
    }

    func resetForm() {
        selectedImage = nil
        stormType = AppConfig.StormTypes.all[0]
        notes = ""
        intensity = 2
        duration = ""
        showMetadataForm = false
        weatherData = nil
        currentLocation = nil
    }
}
