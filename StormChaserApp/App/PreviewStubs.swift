import Foundation

struct StubWeatherRepository: WeatherRepositoryProtocol {
    func getWeather(country: String, latitude: Double, longitude: Double) async throws -> Weather {
        Weather(
            source: "stub",
            location: "Preview",
            temperature: 21.0,
            windSpeed: "8",
            windDirection: "NW",
            humidity: 55.0,
            description: "Partly Cloudy",
            observedAt: Date()
        )
    }

    func getForecast(country: String, latitude: Double, longitude: Double) async throws -> WeatherForecast {
        WeatherForecast(
            source: "stub",
            location: "Preview",
            periods: [
                ForecastPeriod(name: "Tonight", temperature: 16, windSpeed: "6", windDirection: "N", description: "Clear"),
                ForecastPeriod(name: "Tomorrow", temperature: 23, windSpeed: "10", windDirection: "NW", description: "Sunny"),
            ]
        )
    }
}
