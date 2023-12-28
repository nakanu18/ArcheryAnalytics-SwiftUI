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
    @State private var showRound = false

    var body: some View {
        List {
            Section("Info") {
                Text("Total Rounds: \(storeModel.rounds.count)")
            }
            
            Section("Rounds") {
                ForEach(Array(storeModel.rounds.enumerated()), id: \.element.id) { offset, element in
                    let round = element

                    HStack {
                        Text("\(offset)")
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
                    .onTapGesture {
                        showRound = true
                        storeModel.selectedRoundID = round.id
                    }
                }
                .onDelete { offsets in
                    storeModel.rounds.remove(atOffsets: offsets)
                }
            }
        }
        .navigationTitle("Rounds")
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
                showRound = true
            }
        })
        .navigationDestination(isPresented: $showRound, destination: {
            if storeModel.isSelectedRoundValid {
                RoundEditorScreen(selectedRound: $storeModel.selectedRound)
            }
        })
    }
}

#Preview {
    NavigationStack {
        RoundsScreen()
            .environmentObject(StoreModel.mockEmpty)
    }
}
