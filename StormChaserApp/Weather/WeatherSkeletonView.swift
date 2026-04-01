//
//  WeatherSkeletonView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct WeatherSkeletonView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 24) {
            // Current temperature placeholder
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 160, height: 72)
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 120, height: 20)
            }

            // Humidity + Wind placeholders
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                RoundedRectangle(cornerRadius: 8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }

            // Forecast rows placeholder
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 120, height: 20)
                    .padding(.bottom, 4)

                ForEach(0 ..< 7, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 8)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
            }

            Spacer()
        }
        .padding()
        .redacted(reason: .placeholder)
        .opacity(isAnimating ? 0.4 : 1.0)
        .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear { isAnimating = true }
    }
}

#Preview {
    WeatherSkeletonView()
}
