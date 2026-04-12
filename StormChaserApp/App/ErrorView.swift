//
//  ErrorView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.red)

            Text("Error")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)

            Text("Pull down to retry")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ErrorView(message: "ERROR")
}
