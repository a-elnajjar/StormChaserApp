import Foundation

enum URLCacheProvider {
    nonisolated static func createWeatherCache() -> URLCache {
        return URLCache(
            // 10 MB in memory, 50 MB on disk
            memoryCapacity: 10 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024,
            diskPath: "com.stormchaser.weathercache"
        )
    }

    nonisolated static func createConfiguredSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.urlCache = createWeatherCache()
        config.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: config)
    }
}
