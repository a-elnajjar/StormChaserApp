//
//  RadarMapCard.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-07.
//

import MapKit
import SwiftUI

// MARK: - RainViewer API Models

private nonisolated struct RainViewerResponse: Decodable, Sendable {
    let radar: RadarData
}

private nonisolated struct RadarData: Decodable, Sendable {
    let past: [RadarFrame]
}

private nonisolated struct RadarFrame: Decodable, Sendable {
    let time: Int
    let path: String
}

// MARK: - MKMapView Wrapper

private struct RadarMapViewRepresentable: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    let radarPath: String?

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.isRotateEnabled = false
        map.isPitchEnabled = false
        map.delegate = context.coordinator
        map.setRegion(
            MKCoordinateRegion(center: coordinate, latitudinalMeters: 500_000, longitudinalMeters: 500_000),
            animated: false
        )
        return map
    }

    func updateUIView(_ map: MKMapView, context _: Context) {
        map.removeOverlays(map.overlays)
        if let path = radarPath {
            let urlTemplate = "https://tilecache.rainviewer.com\(path)/256/{z}/{x}/{y}/2/1_1.png"
            let overlay = MKTileOverlay(urlTemplate: urlTemplate)
            overlay.canReplaceMapContent = false
            map.addOverlay(overlay, level: .aboveRoads)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let tile = overlay as? MKTileOverlay else {
                return MKOverlayRenderer(overlay: overlay)
            }
            return MKTileOverlayRenderer(tileOverlay: tile)
        }
    }
}

// MARK: - Radar Map Card

struct RadarMapCard: View {
    let latitude: Double
    let longitude: Double

    @Environment(AppDependencies.self) private var dependencies
    @State private var radarPath: String?
    @State private var radarTime: Date?
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Live Radar", systemImage: "antenna.radiowaves.left.and.right")
                    .font(.headline)
                Spacer()
                if let time = radarTime {
                    Text(time, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ZStack {
                RadarMapViewRepresentable(
                    coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    radarPath: radarPath
                )
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                if isLoading {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                        .frame(height: 200)
                        .overlay { ProgressView() }
                }
            }

            Text("Powered by RainViewer")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .task {
            await fetchRadarData()
        }
    }

    private func fetchRadarData() async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "https://api.rainviewer.com/public/weather-maps.json") else { return }

        do {
            let decoded: RainViewerResponse = try await dependencies.networkClient.get(url: url)
            if let latest = decoded.radar.past.last {
                radarPath = latest.path
                radarTime = Date(timeIntervalSince1970: TimeInterval(latest.time))
            }
        } catch {
            // Map renders without radar overlay on failure
        }
    }
}

#Preview {
    ScrollView {
        RadarMapCard(latitude: 40.7128, longitude: -74.0060)
            .padding()
    }
    .environment(AppDependencies.preview())
}
