@testable import StormChaserApp
import Testing

struct TemperatureFormatterTests {
    @Test("Freezing point 32°F formats to a non-empty string")
    func freezingPoint() {
        let result = TemperatureFormatter.format(32)
        // The display unit depends on device locale (°C in Canada, °F in the US)
        // We verify the output is non-empty and contains a degree symbol
        #expect(!result.isEmpty)
        #expect(result.contains("°"))
    }

    @Test("Boiling point 212°F formats to a non-empty string")
    func boilingPoint() {
        let result = TemperatureFormatter.format(212)
        #expect(!result.isEmpty)
        #expect(result.contains("°"))
    }

    @Test("Double extension matches TemperatureFormatter output")
    func doubleExtension_matchesFormatter() {
        let fahrenheit = 72.0
        #expect(fahrenheit.formattedTemperature() == TemperatureFormatter.format(fahrenheit))
    }
}
