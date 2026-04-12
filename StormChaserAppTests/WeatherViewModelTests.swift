import Foundation
@testable import StormChaserApp
import Testing

// MARK: - Mock

final class MockWeatherRepository: WeatherRepositoryProtocol {
    var currentToReturn: Weather?
    var forecastToReturn: [WeatherForecast] = []
    var errorToThrow: Error?

    func getWeather(latitude _: Double, longitude _: Double) async throws -> Weather {
        if let error = errorToThrow { throw error }
        return currentToReturn ?? Weather(
            source: "weather.gov",
            location: "KNYC",
            temperature: 0,
            windSpeed: "N/A",
            windDirection: "N/A",
            humidity: 0,
            description: "No description",
            observedAt: Date()
        )
    }

    func getForecast(latitude _: Double, longitude _: Double) async throws -> [WeatherForecast] {
        if let error = errorToThrow { throw error }
        return forecastToReturn
    }
}

// MARK: - Tests

@MainActor
struct WeatherViewModelTests {
    private func makeCurrentWeather() -> Weather {
        Weather(
            source: "weather.gov",
            location: "KNYC",
            temperature: 11.1,
            windSpeed: "9.4",
            windDirection: "N/A",
            humidity: 34.7,
            description: "Clear",
            observedAt: Date()
        )
    }

    private func makeForecast() -> [WeatherForecast] {
        [
            WeatherForecast(
                source: "weather.gov",
                location: "KNYC",
                periods: [
                    ForecastPeriod(
                        name: "Tonight",
                        temperature: 8.0,
                        windSpeed: "8",
                        windDirection: "NW",
                        description: "Clear"
                    ),
                ]
            ),
        ]
    }

    @Test("Initial state is idle")
    func initialState_isIdle() {
        let mock = MockWeatherRepository()
        let viewModel = WeatherViewModel(repository: mock)

        if case .idle = viewModel.state { } else {
            Issue.record("Expected .idle, got \(viewModel.state)")
        }
    }

    @Test("Fetch success transitions state to success with current and forecast")
    func fetchWeather_success_stateIsSuccess() async {
        let mock = MockWeatherRepository()
        mock.currentToReturn = makeCurrentWeather()
        mock.forecastToReturn = makeForecast()
        let viewModel = WeatherViewModel(repository: mock)

        await viewModel.fetchWeather(latitude: 40.7128, longitude: -74.0060)

        if case let .success(current, forecast) = viewModel.state {
            #expect(current.location == "KNYC")
            #expect(forecast.count == 1)
            #expect(forecast.first?.periods.isEmpty == false)
        } else {
            Issue.record("Expected .success, got \(viewModel.state)")
        }
    }

    @Test("Fetch NetworkError transitions state to error with description")
    func fetchWeather_networkError_stateIsError() async {
        let mock = MockWeatherRepository()
        mock.errorToThrow = NetworkError.networkError
        let viewModel = WeatherViewModel(repository: mock)

        await viewModel.fetchWeather(latitude: 40.7128, longitude: -74.0060)

        if case let .error(message) = viewModel.state {
            #expect(!message.isEmpty)
        } else {
            Issue.record("Expected .error, got \(viewModel.state)")
        }
    }

    @Test("Fetch unknown error transitions state to generic error message")
    func fetchWeather_unknownError_stateIsGenericError() async {
        let mock = MockWeatherRepository()
        mock.errorToThrow = URLError(.notConnectedToInternet)
        let viewModel = WeatherViewModel(repository: mock)

        await viewModel.fetchWeather(latitude: 40.7128, longitude: -74.0060)

        if case let .error(message) = viewModel.state {
            #expect(message == "Failed to fetch weather")
        } else {
            Issue.record("Expected .error, got \(viewModel.state)")
        }
    }
}