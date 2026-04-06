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
    @State private var showSettings = false
    @Environment(AppState.self) private var appState

    private var latitude: Double {
        appState.debugCity?.latitude ?? AppConfig.Locations.newYorkCityLatitude
    }

    private var longitude: Double {
        appState.debugCity?.longitude ?? AppConfig.Locations.newYorkCityLongitude
    }

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
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .refreshable {
                    await fetchWeatherData()
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environment(appState)
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
        .onChange(of: appState.debugCity?.id) {
            Task { await fetchWeatherData() }
        }
    }

    private func fetchWeatherData() async {
        await weatherVM.fetchWeather(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    ContentView()
}
