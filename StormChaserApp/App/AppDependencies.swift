import SwiftUI

@Observable
@MainActor
final class AppDependencies {
    let weatherRepository: WeatherRepositoryProtocol
    let locationManager: LocationManager

    init(
        weatherRepository: WeatherRepositoryProtocol,
        locationManager: LocationManager
    ) {
        self.weatherRepository = weatherRepository
        self.locationManager = locationManager
    }

    func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(repository: weatherRepository)
    }

    func makeAppState() -> AppState {
        AppState(locationManager: locationManager)
    }

    static func live() -> AppDependencies {
        AppDependencies(
            weatherRepository: WeatherRepository(networkClient: NetworkClient()),
            locationManager: LocationManager()
        )
    }
}
