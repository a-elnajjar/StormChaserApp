//
//  AppState.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import CoreLocation
import SwiftUI

@Observable
@MainActor
class AppState {
    var locationManager: LocationManager
    var debugCity: AppConfig.DebugCity?

    var userLocation: CLLocationCoordinate2D? {
        locationManager.userLocation
    }

    var isLocationAvailable: Bool {
        locationManager.isLocationAvailable
    }

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
}
