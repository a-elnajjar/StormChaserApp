@testable import StormChaserApp
import Testing

struct WeatherRepositoryIntegrationTests {
    @Test("API returns weather data with valid values")
    func getWeather_returnsData() async throws {
        let repository = await WeatherRepository(networkClient: NetworkClient())

        let weather = try await repository.getWeather(
            latitude: AppConfig.Locations.newYorkCityLatitude,
            longitude: AppConfig.Locations.newYorkCityLongitude
        )

        #expect(!weather.description.isEmpty)
        #expect(!weather.windSpeed.isEmpty)
        #expect(!weather.windDirection.isEmpty)
        #expect(weather.humidity >= 0 && weather.humidity <= 100)
        #expect(weather.temperature >= -60 && weather.temperature <= 150)
    }

    @Test("API returns forecast with up to 7 periods")
    func getWeather_returnsForecast() async throws {
        let repository = await WeatherRepository(networkClient: NetworkClient())

        let weather = try await repository.getWeather(
            latitude: AppConfig.Locations.newYorkCityLatitude,
            longitude: AppConfig.Locations.newYorkCityLongitude
        )

        #expect(!weather.forecast.isEmpty)
        #expect(weather.forecast.count <= 7)

        for period in await weather.forecast {
            #expect(!period.name.isEmpty)
            #expect(!period.description.isEmpty)
        }
    }

    @Test("Coordinates outside the US throw an error")
    func getWeather_invalidCoordinates_throwsError() async {
        let repository = await WeatherRepository(networkClient: NetworkClient())

        await #expect(throws: (any Error).self) {
            try await repository.getWeather(latitude: 0, longitude: 0)
        }
    }
}
