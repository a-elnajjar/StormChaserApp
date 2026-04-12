//
//  MetadataFormView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct MetadataFormView: View {
    @Binding var stormType: String
    @Binding var notes: String
    @Binding var intensity: Int
    @Binding var duration: String

    let temperature: Double?
    let humidity: Double?
    let windSpeed: String?
    let weatherDescription: String?
    let latitude: Double
    let longitude: Double
    let onSave: () -> Void

    @Environment(\.dismiss) var dismiss

    let stormTypes = AppConfig.StormTypes.all

    var body: some View {
        Form {
                Section("Storm Type") {
                    Picker("Type", selection: $stormType) {
                        ForEach(stormTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }

                Section("Intensity") {
                    Slider(value: Binding<Double>(
                        get: { Double(intensity) },
                        set: { intensity = Int($0) }
                    ), in: 1 ... 4, step: 1)
                    Text("Level \(intensity)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                Section("Duration") {
                    HStack {
                        TextField("Minutes", text: $duration)
                            .keyboardType(.numberPad)
                        Text("min")
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }

                Section("Weather Conditions") {
                    VStack(alignment: .leading, spacing: 8) {
                        if let temp = temperature {
                            HStack {
                                Text("Temperature")
                                Spacer()
                                Text("\(temp, specifier: "%.1f")°C")
                                    .fontWeight(.semibold)
                            }
                        }
                        if let humidity = humidity {
                            HStack {
                                Text("Humidity")
                                Spacer()
                                Text("\(Int(humidity))%")
                                    .fontWeight(.semibold)
                            }
                        }
                        if let wind = windSpeed {
                            HStack {
                                Text("Wind")
                                Spacer()
                                Text(wind)
                                    .fontWeight(.semibold)
                            }
                        }
                        if let desc = weatherDescription {
                            HStack {
                                Text("Conditions")
                                Spacer()
                                Text(desc)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .font(.subheadline)
                }

                Section("Location") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Latitude")
                            Spacer()
                            Text(String(format: "%.4f", latitude))
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                        HStack {
                            Text("Longitude")
                            Spacer()
                            Text(String(format: "%.4f", longitude))
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                    }
                    .font(.subheadline)
                }

                Section {
                    Button(action: {
                        onSave()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Storm")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Storm Details")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MetadataFormView(stormType: .constant("Thunderstorm"), notes: .constant(""), intensity: .constant(2), duration: .constant(""), temperature: 15.2, humidity: 65, windSpeed: "12 km/h SW", weatherDescription: "Partly Cloudy", latitude: 42.989, longitude: -81.291, onSave: {})
}
