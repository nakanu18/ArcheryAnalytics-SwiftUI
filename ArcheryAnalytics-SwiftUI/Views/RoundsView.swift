//
//  ContentView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundsView: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    @State private var showNewRoundSheet = false
    @State private var showRound = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Info") {
                    Text("Total Rounds: \(storeModel.rounds.count)")
                }
                
                Section("Rounds") {
                    ForEach(storeModel.rounds) { round in
                        HStack {
                            Text("ID: \(round.id)")
                            Spacer()
                            Text("\(round.totalScore)")
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        .onTapGesture {
                            showRound = true
                            storeModel.selectedRoundID = round.id
                        }
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
                RoundEditorView()
            })
        }
    }
    
}

#Preview {
    RoundsView()
        .environmentObject(StoreModel.mock)
}
