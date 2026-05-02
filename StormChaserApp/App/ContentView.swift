//
//  ContentView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import CoreLocation
import MapKit
import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var weatherVM = WeatherViewModel(
        repository: WeatherRepository(networkClient: NetworkClient())
    )
    @State private var showSettings = false
    @State private var locationTitle = "Weather"
	@State private var countryCode: String = ""
    @Environment(AppState.self) private var appState

    private var latitude: Double {
        appState.debugCity?.latitude ?? appState.userLocation?.latitude ?? AppConfig.Locations.newYorkCityLatitude
    }

    private var longitude: Double {
        appState.debugCity?.longitude ?? appState.userLocation?.longitude ?? AppConfig.Locations.newYorkCityLongitude
    }

    var body: some View {
        TabView {
            // Tab 1: Weather
            NavigationStack {
                ScrollView {
                    switch weatherVM.state {
                    case .idle, .loading:
                        WeatherSkeletonView()

                    case let .success(weather, forecast):
                        WeatherView(weather: weather, forecast: forecast, latitude: latitude, longitude: longitude)

                    case let .error(message):
                        ErrorView(message: message)
                    }
                }
                .navigationTitle(locationTitle)
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
            await resolveLocationTitle()
            await fetchWeatherData()
        }
        .onChange(of: appState.debugCity?.id) {
            Task {
                await resolveLocationTitle()
                await fetchWeatherData()
            }
        }
    }

    private func fetchWeatherData() async {
		await weatherVM.fetchWeather(country:countryCode , latitude: latitude, longitude: longitude)
    }

    private func resolveLocationTitle() async {
        if let city = appState.debugCity {
            locationTitle = city.name
			countryCode = city.countryCode
            return
        }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try? await CLGeocoder().reverseGeocodeLocation(location)
        if let place = placemarks?.first {
            locationTitle = place.locality ?? place.administrativeArea ?? "Weather"
			countryCode = place.isoCountryCode ?? "" 
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
        .modelContainer(for: Storm.self, inMemory: true)
}
