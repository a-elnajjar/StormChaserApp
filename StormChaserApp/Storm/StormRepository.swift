//
//  StormRepository.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation
import SwiftData

nonisolated struct StormSnapshot: Identifiable, Hashable, Sendable {
    var id: UUID
    var photoData: Data?
    var temperature: Double?
    var humidity: Double?
    var windSpeed: String?
    var weatherDescription: String?
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var notes: String
    var stormType: String
    var intensity: Int?
    var duration: Int?

    init(
        id: UUID = UUID(),
        photoData: Data? = nil,
        temperature: Double? = nil,
        humidity: Double? = nil,
        windSpeed: String? = nil,
        weatherDescription: String? = nil,
        latitude: Double,
        longitude: Double,
        timestamp: Date = Date(),
        notes: String = "",
        stormType: String,
        intensity: Int? = nil,
        duration: Int? = nil
    ) {
        self.id = id
        self.photoData = photoData
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.weatherDescription = weatherDescription
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.notes = notes
        self.stormType = stormType
        self.intensity = intensity
        self.duration = duration
    }
}

nonisolated protocol StormRepositoryProtocol: Sendable {
    func addStorm(_ snapshot: StormSnapshot) async throws
    func getStorms() async throws -> [StormSnapshot]
    func deleteStorm(id: UUID) async throws
}

@ModelActor
actor StormRepository: StormRepositoryProtocol {
    func addStorm(_ snapshot: StormSnapshot) async throws {
        let storm = Storm(
            photoData: snapshot.photoData,
            temperature: snapshot.temperature,
            humidity: snapshot.humidity,
            windSpeed: snapshot.windSpeed,
            weatherDescription: snapshot.weatherDescription,
            latitude: snapshot.latitude,
            longitude: snapshot.longitude,
            timestamp: snapshot.timestamp,
            notes: snapshot.notes,
            stormType: snapshot.stormType,
            intensity: snapshot.intensity,
            duration: snapshot.duration
        )
        storm.id = snapshot.id
        modelContext.insert(storm)
        try modelContext.save()
    }

    func getStorms() async throws -> [StormSnapshot] {
        let descriptor = FetchDescriptor<Storm>(
            sortBy: [SortDescriptor(\Storm.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map { storm in
            StormSnapshot(
                id: storm.id,
                photoData: storm.photoData,
                temperature: storm.temperature,
                humidity: storm.humidity,
                windSpeed: storm.windSpeed,
                weatherDescription: storm.weatherDescription,
                latitude: storm.latitude,
                longitude: storm.longitude,
                timestamp: storm.timestamp,
                notes: storm.notes,
                stormType: storm.stormType,
                intensity: storm.intensity,
                duration: storm.duration
            )
        }
    }

    func deleteStorm(id: UUID) async throws {
        let descriptor = FetchDescriptor<Storm>(predicate: #Predicate { $0.id == id })
        guard let storm = try modelContext.fetch(descriptor).first else { return }
        modelContext.delete(storm)
        try modelContext.save()
    }
}
