//
//  StormRepository.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation
import SwiftData

@MainActor
protocol StormRepositoryProtocol {
    func addStorm(_ storm: Storm) async throws
    func getStorms() async throws -> [Storm]
    func deleteStorm(_ storm: Storm) async throws
}

@MainActor
class StormRepository: StormRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addStorm(_ storm: Storm) async throws {
        modelContext.insert(storm)
        try modelContext.save()
    }

    func getStorms() async throws -> [Storm] {
        let descriptor = FetchDescriptor<Storm>(
            sortBy: [SortDescriptor(\Storm.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func deleteStorm(_ storm: Storm) async throws {
        modelContext.delete(storm)
        try modelContext.save()
    }
}
