//
//  ContentView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundsScreen: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    @EnvironmentObject private var navManager: NavManager
    @State private var showNewRoundSheet = false

    var body: some View {
        List {
            Section("Info") {
                Text("Total Rounds: \(storeModel.rounds.count)")
            }
            
            Section("Rounds") {
                ForEach(storeModel.rounds) { round in
                    RoundCell(round: round) {
                        navManager.push(route: .roundEditor(roundID: round.id))
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
    let storeModel = StoreModel.mockEmpty
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.path) {
        RoundsScreen()
            .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
    }.preferredColorScheme(.dark)
        .environmentObject(storeModel)
        .environmentObject(navManager)
}

struct RoundCell: View {
    var round: Round
    var onRowTap: (() -> Void)?

    var body: some View {
        Button {
            onRowTap?()
        } label: {
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
        }.foregroundColor(.white)
    }
}
