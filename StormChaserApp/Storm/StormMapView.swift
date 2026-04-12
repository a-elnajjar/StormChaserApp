//
//  StormMapView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import MapKit
import SwiftUI

struct StormMapView: View {
    let latitude: Double
    let longitude: Double

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        VStack(spacing: 0) {
            Map(position: $cameraPosition) {
                Annotation("Storm Location", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                    VStack(spacing: 8) {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.red)
                            .shadow(radius: 4)
                    }
                }
            }
            .frame(height: 400)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .onAppear {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                cameraPosition = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.red)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Location")
                            .font(.caption)
                            .foregroundStyle(.gray)

                        Text(String(format: "%.4f, %.4f", latitude, longitude))
                            .font(.body)
                            .fontWeight(.semibold)
                            .monospacedDigit()
                    }

                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

#Preview {
    StormMapView(
        latitude: 40.7128,
        longitude: -74.0060
    )
}
