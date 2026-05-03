import SwiftData
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

    func makeStormRepository(modelContext: ModelContext) -> StormRepositoryProtocol {
        StormRepository(modelContext: modelContext)
    }

    func makeStormViewModel(modelContext: ModelContext) -> StormViewModel {
        StormViewModel(repository: makeStormRepository(modelContext: modelContext))
    }

    static func live() -> AppDependencies {
        AppDependencies(
            weatherRepository: WeatherRepository(networkClient: NetworkClient()),
            locationManager: LocationManager()
        )
    }

    static func preview() -> AppDependencies {
        AppDependencies(
            weatherRepository: StubWeatherRepository(),
            locationManager: LocationManager()
        )
    }
}
