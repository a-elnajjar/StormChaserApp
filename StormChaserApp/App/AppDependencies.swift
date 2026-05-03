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

    func makeStormRepository(container: ModelContainer) -> StormRepositoryProtocol {
        StormRepository(modelContainer: container)
    }

    func makeStormViewModel(container: ModelContainer) -> StormViewModel {
        StormViewModel(repository: makeStormRepository(container: container))
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
