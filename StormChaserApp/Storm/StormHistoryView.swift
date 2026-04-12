//
//  StormHistoryView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct StormHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var stormVM: StormViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let vm = stormVM, !vm.storms.isEmpty {
                    List {
                        ForEach(vm.storms, id: \.id) { storm in
                            NavigationLink(destination: StormDetailView(storm: storm)) {
                                StormRow(storm: storm)
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                for index in indexSet {
                                    await vm.deleteStorm(vm.storms[index])
                                }
                            }
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "cloud.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.gray)
                        Text("No Storms Documented")
                            .font(.headline)
                        Text("Document storms to see them here")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle("Storm History")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                let vm = StormViewModel(repository: StormRepository(modelContext: modelContext))
                stormVM = vm
                await vm.fetchStorms()
            }
            .alert("Error", isPresented: Binding(
                get: { stormVM?.errorMessage != nil },
                set: { if !$0 { stormVM?.errorMessage = nil } }
            )) {
                Button("OK") { stormVM?.errorMessage = nil }
            } message: {
                Text(stormVM?.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    StormHistoryView()
        .modelContainer(for: Storm.self, inMemory: true)
}
