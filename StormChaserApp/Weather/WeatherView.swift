//
//  WeatherView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct WeatherView: View {
    let weather: Weather
	let forecasts: [WeatherForecast]
    let latitude: Double
    let longitude: Double

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("\(weather.temperature, specifier: "%.1f")°C")
                    .font(.system(size: 64, weight: .bold))

                Text(weather.description)
                    .font(.headline)
                    .foregroundStyle(.gray)
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

			if let source = forecasts.first, !source.periods.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("7-Day Forecast")
                        .font(.headline)
                        .padding(.bottom, 4)

					ForEach(source.periods, id: \.name) { period in
                        HStack {
                            Text(period.name)
                                .font(.subheadline)
                                .frame(width: 120, alignment: .leading)
							Text(period.description ?? "")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            Spacer()
							Text("\(period.temperature ?? 0, specifier: "%.1f")°C")
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
    let weather = Weather(
        source: "Preview",
        location: "New York",
        temperature: 72.5,
        windSpeed: "10 mph",
        windDirection: "NE",
        humidity: 65,
        description: "Partly Cloudy",
        observedAt: Date()
    )
    let forecasts = [
        WeatherForecast(source: "Preview", location: "New York", periods: [
            ForecastPeriod(name: "Tonight", temperature: 65, windSpeed: "8 mph", windDirection: "N", description: "Clear"),
            ForecastPeriod(name: "Monday", temperature: 74, windSpeed: "12 mph", windDirection: "NE", description: "Sunny"),
            ForecastPeriod(name: "Monday Night", temperature: 60, windSpeed: "5 mph", windDirection: "S", description: "Cloudy"),
        ])
    ]
    WeatherView(weather: weather, forecasts: forecasts, latitude: 40.7128, longitude: -74.0060)
}
