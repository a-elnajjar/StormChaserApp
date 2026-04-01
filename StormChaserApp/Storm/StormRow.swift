//
//  StormRow.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct StormRow: View {
    let storm: Storm

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(storm.stormType)
                        .font(.headline)
                    Text(storm.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                if let photoData = storm.photoData,
                   let uiImage = UIImage(data: photoData)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Location:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(String(format: "%.3f, %.3f", storm.latitude, storm.longitude))
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                if let temp = storm.temperature,
                   let humidity = storm.humidity
                {
                    HStack {
                        Text(temp.formattedTemperature())
                            .font(.caption)
                        Text("•")
                            .font(.caption)
                        Text("\(Int(humidity))%")
                            .font(.caption)
                        if let wind = storm.windSpeed {
                            Text("•")
                                .font(.caption)
                            Text(wind)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
