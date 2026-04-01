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
                .foregroundColor(.red)

            Text("Error")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Text("Pull down to retry")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    ErrorView(message: "ERROR")
}
