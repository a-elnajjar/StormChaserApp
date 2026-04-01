//
//  StormViewModel.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import Foundation
import SwiftData

@Observable
@MainActor
class StormViewModel {
    var storms: [Storm] = []
    var errorMessage: String?
    private let repository: StormRepositoryProtocol

    init(repository: StormRepositoryProtocol) {
        self.repository = repository
    }

    func fetchStorms() async {
        do {
            storms = try await repository.getStorms()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch storms: \(error.localizedDescription)"
        }
    }

    func addStorm(_ storm: Storm) async {
        do {
            try await repository.addStorm(storm)
            storms.insert(storm, at: 0)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to save storm: \(error.localizedDescription)"
        }
    }

    func deleteStorm(_ storm: Storm) async {
        do {
            try await repository.deleteStorm(storm)
            storms.removeAll { $0.id == storm.id }
            errorMessage = nil
        } catch {
            errorMessage = "Failed to delete storm: \(error.localizedDescription)"
        }
    }
}
