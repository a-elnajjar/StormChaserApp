import Foundation
@testable import StormChaserApp
import Testing

// MARK: - Mock

final class MockWeatherRepository: WeatherRepositoryProtocol {
    var weatherToReturn: Weather?
    var errorToThrow: Error?

    func getWeather(latitude _: Double, longitude _: Double) async throws -> Weather {
        if let error = errorToThrow { throw error }
        return weatherToReturn!
    }
}

// MARK: - Tests

@MainActor
struct WeatherViewModelTests {
    // MARK: Helpers

    private func makeWeather() -> Weather {
        Weather(temperature: 72, windSpeed: "10 mph", windDirection: "NE", humidity: 65, description: "Sunny", forecast: [])
    }

    // MARK: Tests

    @Test("Initial state is idle")
    func initialState_isIdle() {
        let mock = MockWeatherRepository()
        let viewModel = WeatherViewModel(repository: mock)

        if case .idle = viewModel.state { } else {
            Issue.record("Expected .idle, got \(viewModel.state)")
        }
    }

    @Test("Fetch success transitions state to success")
    func fetchWeather_success_stateIsSuccess() async {
        let mock = MockWeatherRepository()
        mock.weatherToReturn = makeWeather()
        let viewModel = WeatherViewModel(repository: mock)

        await viewModel.fetchWeather(latitude: 40.7128, longitude: -74.0060)

        if case let .success(weather) = viewModel.state {
            #expect(weather.temperature == 72)
            #expect(weather.description == "Sunny")
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
