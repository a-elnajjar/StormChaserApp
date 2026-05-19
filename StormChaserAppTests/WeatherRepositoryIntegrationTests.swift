@testable import StormChaserApp
import Testing

struct WeatherRepositoryIntegrationTests {
    @Test("Current weather endpoint returns data with valid values")
    func getWeather_returnsData() async throws {
        let repository = WeatherRepository(networkClient: NetworkClient())

        let weather = try await repository.getWeather(
            latitude: AppConfig.Locations.newYorkCityLatitude,
            longitude: AppConfig.Locations.newYorkCityLongitude
        )

        #expect(!weather.source.isEmpty)
        #expect(!weather.location.isEmpty)
        #expect(!weather.windSpeed.isEmpty)
        #expect(!weather.windDirection.isEmpty)
        #expect(weather.humidity >= 0 && weather.humidity <= 100)
    }

    @Test("Forecast endpoint returns periods")
    func getForecast_returnsPeriods() async throws {
        let repository = WeatherRepository(networkClient: NetworkClient())

        let forecasts = try await repository.getForecast(
            latitude: AppConfig.Locations.newYorkCityLatitude,
            longitude: AppConfig.Locations.newYorkCityLongitude
        )

        #expect(!forecasts.isEmpty)

        let firstForecast = try #require(forecasts.first)
        #expect(!firstForecast.source.isEmpty)
        #expect(!firstForecast.location.isEmpty)
        #expect(!firstForecast.periods.isEmpty)

        for period in firstForecast.periods {
            #expect(!period.name.isEmpty)
        }
    }

    @Test("Coordinates outside the US throw an error")
    func getWeather_invalidCoordinates_throwsError() async {
        let repository = WeatherRepository(networkClient: NetworkClient())

        await #expect(throws: (any Error).self) {
            try await repository.getWeather(latitude: 0, longitude: 0)
        }
    }
}
