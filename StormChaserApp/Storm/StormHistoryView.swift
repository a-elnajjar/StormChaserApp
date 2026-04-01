//
//  StormHistoryView.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-04-01.
//

import SwiftUI

struct StormHistoryView: View {
    @State private var stormVM: StormViewModel?
    @Environment(\.modelContext) private var modelContext

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
                            .foregroundColor(.gray)
                        Text("No Storms Documented")
                            .font(.headline)
                        Text("Document storms to see them here")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle("Storm History")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if stormVM == nil {
                    let repository = StormRepository(modelContext: modelContext)
                    stormVM = StormViewModel(repository: repository)
                }
                await stormVM?.fetchStorms()
            }
            .alert("Error", isPresented: .constant(stormVM?.errorMessage != nil)) {
                Button("OK") {
                    stormVM?.errorMessage = nil
                }
            } message: {
                if let error = stormVM?.errorMessage {
                    Text(error)
                }
            }
        }
    }
}

#Preview {
    StormHistoryView()
}
