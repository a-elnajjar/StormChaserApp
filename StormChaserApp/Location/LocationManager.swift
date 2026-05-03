//
//  LocationManager.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import CoreLocation
import Foundation

@Observable
@MainActor
class LocationManager: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored private let locationManager = CLLocationManager()

    var userLocation: CLLocationCoordinate2D?
    var isLocationAvailable = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
    }

    func requestLocationPermission() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            isLocationAvailable = false
        @unknown default:
            break
        }
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        userLocation = location.coordinate
        isLocationAvailable = true
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        isLocationAvailable = false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            isLocationAvailable = false
        default:
            break
        }
    }
}
