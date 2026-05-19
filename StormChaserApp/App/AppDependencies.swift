import SwiftData
import SwiftUI

@Observable
@MainActor
final class AppDependencies {
    let weatherRepository: WeatherRepositoryProtocol
    let locationManager: LocationManager
    let networkClient: NetworkClient

    init(
        weatherRepository: WeatherRepositoryProtocol,
        locationManager: LocationManager,
        networkClient: NetworkClient
    ) {
        self.weatherRepository = weatherRepository
        self.locationManager = locationManager
        self.networkClient = networkClient
    }

    func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(repository: weatherRepository)
    }

    func makeCameraViewModel() -> CameraViewModel {
        CameraViewModel(weatherRepository: weatherRepository)
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
        let networkClient = NetworkClient()
        return AppDependencies(
            weatherRepository: WeatherRepository(networkClient: networkClient),
            locationManager: LocationManager(),
            networkClient: networkClient
        )
    }

    static func preview() -> AppDependencies {
        AppDependencies(
            weatherRepository: StubWeatherRepository(),
            locationManager: LocationManager(),
            networkClient: NetworkClient()
        )
    }
}
