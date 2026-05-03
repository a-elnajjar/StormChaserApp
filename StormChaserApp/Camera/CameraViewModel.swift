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
    var countryCode: String = ""
    var showSuccessAlert = false
    var alertMessage = ""

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository(networkClient: NetworkClient())) {
        self.weatherRepository = weatherRepository
    }

    func prepareMetadataForm(userLocation: CLLocationCoordinate2D?, debugCity: AppConfig.DebugCity?) async {
        isPreparingMetadata = true
        defer { isPreparingMetadata = false }

        if let city = debugCity {
            currentLocation = (city.latitude, city.longitude)
        } else if let userLocation = userLocation {
            currentLocation = (userLocation.latitude, userLocation.longitude)
        } else {
            currentLocation = (
                AppConfig.Locations.newYorkCityLatitude,
                AppConfig.Locations.newYorkCityLongitude
            )
        }

        if let lat = currentLocation?.lat, let lon = currentLocation?.lon {
            // Resolve country code from coordinates
            countryCode = await resolveCountryCode(latitude: lat, longitude: lon)

            do {
                weatherData = try await weatherRepository.getWeather(
                    country: countryCode,
                    latitude: lat,
                    longitude: lon
                )
            } catch {
                weatherData = nil
                alertMessage = "Could not load weather data: \(error.localizedDescription)"
                showSuccessAlert = true
            }
        }

        showMetadataForm = true
    }

    private func resolveCountryCode(latitude: Double, longitude: Double) async -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try? await CLGeocoder().reverseGeocodeLocation(location)
        return placemarks?.first?.isoCountryCode ?? "US"
    }

    func saveStorm(photo: UIImage, repository: StormRepositoryProtocol) async {
        let trimmedDuration = duration.trimmingCharacters(in: .whitespacesAndNewlines)
        let parsedDuration = trimmedDuration.isEmpty ? nil : Int(trimmedDuration)

        if !trimmedDuration.isEmpty, parsedDuration == nil {
            alertMessage = "Duration must be a whole number of minutes."
            showSuccessAlert = true
            return
        }

        let snapshot = StormSnapshot(
            photoData: photo.jpegData(compressionQuality: 0.8),
            temperature: weatherData?.temperature,
            humidity: weatherData?.humidity,
            windSpeed: weatherData?.windSpeed,
            weatherDescription: weatherData?.description,
            latitude: currentLocation?.lat ?? AppConfig.Locations.newYorkCityLatitude,
            longitude: currentLocation?.lon ?? AppConfig.Locations.newYorkCityLongitude,
            timestamp: Date(),
            notes: notes,
            stormType: stormType,
            intensity: intensity,
            duration: parsedDuration
        )

        do {
            try await repository.addStorm(snapshot)
            alertMessage = """
            Storm saved successfully!

            Type: \(stormType)
            Location: \(String(format: "%.2f°, %.2f°", currentLocation?.lat ?? 0, currentLocation?.lon ?? 0))
            """
            showSuccessAlert = true
            resetForm()
        } catch {
            alertMessage = "Failed to save storm: \(error.localizedDescription)"
            showSuccessAlert = true
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
        countryCode = ""
    }
}
