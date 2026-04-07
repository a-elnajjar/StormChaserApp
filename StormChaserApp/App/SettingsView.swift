//
//  SettingsView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-06.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var debugEnabled: Bool = false

    var body: some View {
        @Bindable var appState = appState

        NavigationStack {
            Form {
                Section {
                    Toggle("Debug Mode", isOn: $debugEnabled)
                } header: {
                    Text("Debug")
                } footer: {
                    Text("Override location with a US city for testing weather data.")
                }

                if debugEnabled {
                    Section("Select City") {
                        ForEach(AppConfig.DebugCities.all) { city in
                            Button {
                                appState.debugCity = city
                            } label: {
                                HStack {
                                    Text(city.name)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if appState.debugCity?.id == city.id {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .onAppear {
                debugEnabled = appState.debugCity != nil
            }
            .onChange(of: debugEnabled) { _, enabled in
                appState.debugCity = enabled ? AppConfig.DebugCities.all.first : nil
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
