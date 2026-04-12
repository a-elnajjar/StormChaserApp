//create a view for the forecast chart using the Charts framework
import SwiftUI
import Charts

struct WeatherPeriod: Identifiable {
    let id = UUID()
    let name: String
    let temperature: Double  
    let description: String
}

struct ForecastChartView: View {
    let forecast: [WeatherPeriod]

    var body: some View {
        Chart(forecast) { period in
            BarMark(
                x: .value("Day", period.name),
                y: .value("Temperature", period.temperature)
            )
            .foregroundStyle(.blue)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
    }
}

#Preview {
    ForecastChartView(forecast: [
        WeatherPeriod(name: "Tonight",    temperature: 62, description: "Clear"),
        WeatherPeriod(name: "Monday",     temperature: 75, description: "Sunny"),
        WeatherPeriod(name: "Mon Night",  temperature: 58, description: "Partly Cloudy"),
        WeatherPeriod(name: "Tuesday",    temperature: 70, description: "Mostly Sunny"),
        WeatherPeriod(name: "Tue Night",  temperature: 55, description: "Cloudy"),
        WeatherPeriod(name: "Wednesday",  temperature: 68, description: "Rain"),
        WeatherPeriod(name: "Thursday",   temperature: 68, description: "Rain")
    ])
}

