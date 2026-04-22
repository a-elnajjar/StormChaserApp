# StormChaser

A take-home assessment for **Speer Technologies**, built for storm-chasing hobbyist meteorologists. StormChaser lets users track the weather, document storms in the field, and review their storm history on an interactive map.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 6 / SwiftUI |
| Concurrency | Swift 6 strict concurrency (`async/await`, `@MainActor`, `actor`) |
| Persistence | SwiftData |
| Maps | MapKit |
| Charts | Swift Charts (in development) |
| State Management | `@Observable` (Observation framework) |
| Networking | Custom `actor`-based `NetworkClient` backed by a .NET API |
| Testing | Swift Testing (`@Test`, `#expect`, `#require`) |

---

## Features

- **7-Day Weather Forecast** — Location-aware weather data with current conditions and daily forecast periods
- **Live Radar Map** — Real-time radar tile overlay via the RainViewer API
- **Storm Documentation** — Capture photos with the device camera, attach metadata (type, intensity, duration, notes)
- **Storm History** — Browse past documented storms with full map visualization and detail views
- **Debug Settings** — Switch between preset US cities for testing weather data without changing physical location
- **Skeleton Loading** — Shimmer placeholder UI while data is being fetched
- **Pull to Refresh** — Swipe down to reload weather data

---

## Architecture

### MVVM

| Layer | Files | Responsibility |
|---|---|---|
| Model | `Storm` (SwiftData), `Weather`, `WeatherForecast`, `ForecastPeriod` | Raw data structures, no business logic |
| ViewModel | `WeatherViewModel`, `StormViewModel`, `CameraViewModel` | Owns state, handles async operations, exposes data to Views |
| View | `WeatherView`, `StormHistoryView`, `CameraView`, etc. | Reads from ViewModel, sends user actions back, no business logic |

### Repository Pattern

ViewModels never know whether data comes from a network call, SwiftData, or a mock — that is the repository's job.

- **`WeatherRepository`** — Calls the backend API and maps raw JSON to domain models (`Weather`, `WeatherForecast`)
- **`StormRepository`** — Handles all SwiftData CRUD operations (insert, fetch, delete)

### Protocols

ViewModels depend on protocols, not concrete types, which means:

- Implementations can be swapped without touching the ViewModel
- Full unit testing is enabled via `MockWeatherRepository` — no real network or database required in tests
- Each layer is independently replaceable (e.g. swap the current backend for another provider by writing a new `WeatherRepositoryProtocol` conformance)

### Concurrency

- **`NetworkClient`** is a Swift `actor`, providing thread-safe networking with no manual locking
- **`@MainActor`** on all ViewModels, `LocationManager`, and `StormRepository` ensures UI state is always updated on the main thread
- **`async let`** for parallel fetching of current weather and forecast data in `WeatherViewModel`

---

## Project Structure

```
StormChaserApp/
├── App/                  # Entry point, AppState, AppConfig, ContentView, SettingsView, ErrorView
├── Camera/               # CameraView, CameraViewModel — photo capture and storm metadata form
├── Extension/            # Temperature formatting utilities (°F ↔ °C)
├── Location/             # LocationManager — GPS permission and coordinate updates
├── Models/               # Shared domain models (Weather, WeatherForecast, ForecastPeriod)
├── Network/              # NetworkClient actor, NetworkError enum
├── Storm/                # StormHistoryView, StormDetailView, StormViewModel,
│                         # StormRepository, StormMapView, MetadataFormView
└── Weather/              # WeatherView, WeatherViewModel, WeatherRepository,
                          # WeatherSkeletonView, RadarMapCard, ForecastChartView (WIP)
```

---

## Backend API

The app connects to a custom **.NET backend API** for weather data:

| Environment | Base URL |
|---|---|
| Debug | `http://localhost:5046/api/weather` |
| Release | _To be configured on deployment_ |

The API provides two endpoints:
- `GET /current?lat={lat}&lon={lon}` — Current weather observation
- `GET /forecast?lat={lat}&lon={lon}` — 7-day forecast

> **Note:** The release URL is a placeholder. See `AppConfig.swift` to configure for your deployment.

---

## How to Run

1. Clone the repository
2. Start the .NET backend API (runs on `localhost:5046`)
3. Open the project in Xcode 16+
4. Select a simulator or connected device
5. Press **Cmd+R** to build and run

> **Note:** Weather data requires the backend API to be running. GPS permissions will be requested on first launch. Use the Debug Settings panel (gear icon) to test with preset US city locations.

---

## Running Tests

1. Open the project in Xcode
2. Press **Cmd+U** to run all tests
3. Tests use the **Swift Testing** framework (requires Xcode 16+)
4. Integration tests require the backend API to be running

### Test Coverage

| Test Suite | Type | Description |
|---|---|---|
| `WeatherRepositoryIntegrationTests` | Integration | Live API call to the backend |
| `WeatherViewModelTests` | Unit | Mocked repository, all state transitions |
| `TemperatureFormatterTests` | Unit | °F to °C conversion logic |

---

## Known Limitations


- **No offline support** — Requires a network connection and the backend API for weather fetches
- **No cloud sync** — Storm data is stored locally on-device via SwiftData
- **Dark mode** — Supported via SwiftUI system defaults but not explicitly designed for
- **Forecast chart** — `ForecastChartView` using Swift Charts is under active development
