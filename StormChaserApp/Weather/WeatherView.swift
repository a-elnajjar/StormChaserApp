//
//  WeatherView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct WeatherView: View {
    let weather: Weather
    let latitude: Double
    let longitude: Double

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(weather.temperature.formattedTemperature())
                    .font(.system(size: 64, weight: .bold))

                Text(weather.description)
                    .font(.headline)
                    .foregroundColor(.gray)
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Humidity")
                    Spacer()
                    Text("\(Int(weather.humidity))%")
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)

                HStack {
                    Text("Wind")
                    Spacer()
                    Text("\(weather.windSpeed) \(weather.windDirection)")
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            if !weather.forecast.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("7-Day Forecast")
                        .font(.headline)
                        .padding(.bottom, 4)

                    ForEach(weather.forecast, id: \.name) { period in
                        HStack {
                            Text(period.name)
                                .font(.subheadline)
                                .frame(width: 120, alignment: .leading)
                            Text(period.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                            Spacer()
                            Text(period.temperature.formattedTemperature())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }

            RadarMapCard(latitude: latitude, longitude: longitude)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    let weather = Weather(temperature: 72.5, windSpeed: "10 mph", windDirection: "NE", humidity: 65, description: "Partly Cloudy",
                          forecast: [
                              ForecastPeriod(name: "Tonight", temperature: 65, windSpeed: "8 mph", description: "Clear"),
                              ForecastPeriod(name: "Monday", temperature: 74, windSpeed: "12 mph", description: "Sunny"),
                              ForecastPeriod(name: "Monday Night", temperature: 60, windSpeed: "5 mph", description: "Cloudy"),
                          ])
    WeatherView(weather: weather, latitude: 40.7128, longitude: -74.0060)
}
