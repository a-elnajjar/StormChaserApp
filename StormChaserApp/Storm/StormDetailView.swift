//
//  StormDetailView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//
import SwiftUI

struct StormDetailView: View {
    let storm: StormSnapshot
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                StormMapView(latitude: storm.latitude, longitude: storm.longitude)

                if let photoData = storm.photoData,
                   let uiImage = UIImage(data: photoData)
                {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Photo")
                            .font(.headline)

                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    }
                    .padding()
                }
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(label: "Type", value: storm.stormType)
                        DetailRow(label: "Date", value: storm.timestamp.formatted(date: .abbreviated, time: .shortened))
                        DetailRow(label: "Latitude", value: String(format: "%.4f", storm.latitude))
                        DetailRow(label: "Longitude", value: String(format: "%.4f", storm.longitude))

                        if let temp = storm.temperature {
                            DetailRow(label: "Temperature", value: temp.formattedTemperature())
                        }
                        if let humidity = storm.humidity {
                            DetailRow(label: "Humidity", value: "\(Int(humidity))%")
                        }
                        if let wind = storm.windSpeed {
                            DetailRow(label: "Wind", value: wind)
                        }
                        if let desc = storm.weatherDescription {
                            DetailRow(label: "Conditions", value: desc)
                        }
                        if let intensity = storm.intensity {
                            DetailRow(label: "Intensity", value: "Level \(intensity)")
                        }
                        if !storm.notes.isEmpty {
                            DetailRow(label: "Notes", value: storm.notes)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Storm Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
