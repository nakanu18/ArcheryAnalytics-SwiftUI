//
//  ContentView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundsScreen: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    @State private var showNewRoundSheet = false

    var body: some View {
        List {
            Section("Info") {
                Text("Total Rounds: \(storeModel.rounds.count)")
            }
            
            Section("Rounds") {
                ForEach(storeModel.rounds) { round in
                    let selectedRound = $storeModel.rounds[$storeModel.rounds.firstIndex(where: { $0.id == round.id })!]
                    NavigationLink(destination: RoundEditorScreen(selectedRound: selectedRound)) {
                        RoundCell(round: round)
                    }
                }.onDelete { offsets in
                    storeModel.rounds.remove(atOffsets: offsets)
                }
            }
        }.navigationTitle("Rounds")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Round") {
                        showNewRoundSheet = true
                    }
                }
            }
            .sheet(isPresented: $showNewRoundSheet, content: {
                Button("WA 18m Round") {
                    storeModel.createNewRound()
                    showNewRoundSheet = false
                }
            })
    }
}

#Preview {
    NavigationStack {
        RoundsScreen()
            .environmentObject(StoreModel.mockEmpty)
            .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
    }
}

struct RoundCell: View {
    var round: Round
    
    var body: some View {
        HStack {
            VStack {
                Text("\(round.name)")
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
                Text(round.date, formatter: DateFormatter.shortFormatter)
                    .font(.caption)
            }
            Spacer()
            Text("\(round.totalScore)")
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
        .contentShape(Rectangle()) // Make the entire HStack tappable
    }
}
