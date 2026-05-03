//
//  ContentView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import CoreLocation
import MapKit
import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var weatherVM: WeatherViewModel?
    @State private var showSettings = false
    @State private var locationTitle = "Weather"
    @Environment(AppState.self) private var appState
    @Environment(AppDependencies.self) private var dependencies

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
                    switch weatherVM?.state ?? .idle {
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
                    await loadCurrentLocation()
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
            CameraView(cameraVM: dependencies.makeCameraViewModel())
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
            if weatherVM == nil {
                weatherVM = dependencies.makeWeatherViewModel()
            }
            await loadCurrentLocation()
        }
        .onChange(of: appState.debugCity?.id) {
            Task { await loadCurrentLocation() }
        }
    }

    private func loadCurrentLocation() async {
        let lat = latitude
        let lon = longitude
        let resolved = await resolveLocation(latitude: lat, longitude: lon)
        locationTitle = resolved.title
        await weatherVM?.fetchWeather(country: resolved.countryCode, latitude: lat, longitude: lon)
    }

    private func resolveLocation(latitude: Double, longitude: Double) async -> (title: String, countryCode: String) {
        if let city = appState.debugCity {
            return (city.name, city.countryCode)
        }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try? await CLGeocoder().reverseGeocodeLocation(location)
        if let place = placemarks?.first {
            return (place.locality ?? place.administrativeArea ?? "Weather", place.isoCountryCode ?? "")
        }
        return ("Weather", "")
    }
}

#Preview {
    let dependencies = AppDependencies.preview()
    return ContentView()
        .environment(dependencies.makeAppState())
        .environment(dependencies)
        .modelContainer(for: Storm.self, inMemory: true)
}
