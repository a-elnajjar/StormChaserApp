//
//  Storm.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation
import SwiftData

@Model
final nonisolated class Storm {
    var id: UUID = UUID()
    var photoData: Data?
    var temperature: Double?
    var humidity: Double?
    var windSpeed: String?
    var weatherDescription: String?
    var latitude: Double
    var longitude: Double
    var timestamp: Date = Date()
    var notes: String = ""
    var stormType: String
    var intensity: Int?
    var duration: Int?

    init(photoData: Data? = nil, temperature: Double? = nil, humidity: Double? = nil,
         windSpeed: String? = nil, weatherDescription: String? = nil, latitude: Double, longitude: Double, timestamp: Date = Date(), notes: String = "", stormType: String, intensity: Int? = nil, duration: Int? = nil)
    {
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
