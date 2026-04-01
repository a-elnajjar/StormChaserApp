# StoreChaser

A take-home assessment for **Speer Technologies**, built for storm-chasing hobbyist meteorologists. StoreChaser lets users track the weather, document storms in the field, and review their storm history on an interactive map.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift / SwiftUI |
| Concurrency | Swift 6 (`async/await`, `@MainActor`, `actor`) |
| Persistence | SwiftData |
| Maps | MapKit |
| State Management | `@Observable` (modern replacement for `ObservableObject`) |

---

## Features

- **7-Day Weather Forecast** — Location-aware weather data with daily forecast periods
- **Storm Documentation** — Capture photos with the device camera, attach metadata and storm type
- **Storm History** — Browse past documented storms with full map visualization

---

## Architecture

### MVVM

| Layer | Files | Responsibility |
|---|---|---|
| Model | `Storm` (SwiftData), `Weather`, `ForecastPeriod` | Raw data structures, no business logic |
| ViewModel | `WeatherViewModel`, `StormViewModel`, `CameraViewModel` | Owns state, handles async operations, exposes data to Views |
| View | `WeatherView`, `StormHistoryView`, `CameraView`, etc. | Reads from ViewModel, sends user actions back, no business logic |

### Repository Pattern

ViewModels never know whether data comes from a network call, SwiftData, or a mock — that is the repository's job.

- **`WeatherRepository`** — Handles `weather.gov` API calls and maps raw JSON (`Period`) to domain models (`Weather`, `ForecastPeriod`)
- **`StormRepository`** — Handles all SwiftData CRUD operations (insert, fetch, delete)

### Protocols

ViewModels depend on protocols, not concrete types, which means:

- Implementations can be swapped without touching the ViewModel
- Full unit testing is enabled via `MockWeatherRepository` and `MockStormRepository` — no real network or database required in tests
- Each layer is independently replaceable (e.g. swap `weather.gov` for `open-meteo` by writing a new `WeatherRepositoryProtocol` conformance)

---

## Project Structure

```
App/
├── App/                  # Entry point, AppState, AppConfig, ContentView
├── Camera/               # CameraView, CameraViewModel — photo capture and storm metadata form
├── Storm/                # StormHistoryView, StormDetailView, StormViewModel,
│                         # StormRepository, StormMapView
├── Weather/              # WeatherView, WeatherViewModel, WeatherRepository,
│                         # WeatherSkeletonView
└── Location/             # LocationManager — GPS permission and coordinate updates
```

---

## How to Run

1. Clone the repository
2. Open the project in Xcode 16+
3. Select a simulator or connected device
4. Press **Cmd+R** to build and run

> **Note:** Weather data requires a network connection. GPS permissions will be requested on first launch.

---

## Running Tests

1. Open the project in Xcode
2. Press **Cmd+U** to run all tests
3. Tests use the **Swift Testing** framework (requires Xcode 16+)
4. Integration tests require an active network connection

### Test Coverage

| Test Suite | Type | Description |
|---|---|---|
| `WeatherRepositoryIntegrationTests` | Integration | Live API call to `weather.gov` |
| `WeatherViewModelTests` | Unit | Mocked repository, all state transitions |
| `TemperatureFormatterTests` | Unit | °F to °C conversion logic |

---

## Bonus Features

- Weather forecast integration
- Map visualization of storm history
- Skeleton screens (loading states)
- Pull to refresh
- Dark mode (system default)

---

## Known Limitations

- **Weather location** — Always shows NYC data due to `weather.gov` being US-only and a hardcoded default coordinate
- **No offline support** — Requires a network connection for weather fetches
- **No cloud integration** — Storm data is stored locally on-device only
- **Dark mode** — Supported via SwiftUI system defaults but was not explicitly designed or tested for
