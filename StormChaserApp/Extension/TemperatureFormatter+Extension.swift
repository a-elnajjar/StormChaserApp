//
//  TemperatureFormatter+Extension.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation

enum TemperatureFormatter {
    static func format(_ fahrenheit: Double) -> String {
        let celsius = (fahrenheit - 32) * 5 / 9
        let rounded = celsius.rounded()
        let measurement = Measurement(value: rounded, unit: UnitTemperature.celsius)
        return measurement.formatted(.measurement(width: .abbreviated, usage: .weather))
    }
}

extension Double {
    func formattedTemperature() -> String {
        return TemperatureFormatter.format(self)
    }
}
