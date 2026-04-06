//
//  StormChaserApp.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftData
import SwiftUI

@main
struct StormChaserApp: App {
    @State private var appState = AppState()
    private let modelContainerResult: Result<ModelContainer, Error> = {
        let schema = Schema([Storm.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return .success(try ModelContainer(for: schema, configurations: [modelConfiguration]))
        } catch {
            return .failure(error)
        }
    }()

    var body: some Scene {
        WindowGroup {
            switch modelContainerResult {
            case .success(let container):
                ContentView()
                    .environment(appState)
                    .modelContainer(container)
            case .failure(let error):
                ErrorView(message: "Failed to load storage: \(error.localizedDescription)")
            }
        }
    }
}
