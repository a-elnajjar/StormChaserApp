//
//  ContentView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct ContentView: View {
    @State private var weatherVM = WeatherViewModel(
        repository: WeatherRepository(networkClient: NetworkClient())
    )
    private let latitude = AppConfig.Locations.newYorkCityLatitude
    private let longitude = AppConfig.Locations.newYorkCityLongitude
    @Environment(AppState.self) private var appState

    var body: some View {
        TabView {
            // Tab 1: Weather
            NavigationStack {
                ScrollView {
                    switch weatherVM.state {
                    case .idle, .loading:
                        WeatherSkeletonView()

                    case let .success(weather):
                        WeatherView(weather: weather)

                    case let .error(message):
                        ErrorView(message: message)
                    }
                }
                .navigationTitle("Weather")
                .navigationBarTitleDisplayMode(.inline)
                .refreshable {
                    await fetchWeatherData()
                }
            }
            .tabItem {
                Label("Weather", systemImage: "cloud.sun")
            }

            // Tab 2: Camera
            CameraView()
                .tabItem {
                    Label("Document", systemImage: "camera")
                }

            // Tab 3: History
            StormHistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }
        }
        .task {
            await fetchWeatherData()
        }
    }

    private func fetchWeatherData() async {
        await weatherVM.fetchWeather(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    ContentView()
}
