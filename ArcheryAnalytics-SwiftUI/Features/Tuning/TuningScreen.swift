//
//  TuningScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/8/25.
//

import SwiftUI

struct TuningScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @EnvironmentObject private var navManager: NavManager
    @EnvironmentObject private var alertManager: AlertManager
    @State private var showNewRoundSheet = false

    var body: some View {
        List {
            Section("Info") {
                KeyValueCell(key: "Number of Tests", value: "\(storeModel.tuningRounds.count)")
            }
            
            Section("Tests") {
                ForEach(storeModel.tuningRounds) { round in
                    RoundCell(round: round) {
                        navManager.push(route: .tuningEditor(round: round))
                    }
                }
                .onDelete { offsets in
                    storeModel.tuningRounds.remove(atOffsets: offsets)
                }
            }
        }
        .navigationTitle("Tuning")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showNewRoundSheet = true
                } label: {
                    Image(systemName: "plus.circle")
                }
                .padding(.trailing, 16)
            }
        }
        .sheet(isPresented: $showNewRoundSheet) {
            VStack(spacing: 20) {
                Button("Fine Tuning 50m") {
                    let newRound = storeModel.createNewTuningRound(roundType: .fineTuning(distance: 50))
                    navManager.push(route: .roundEditor(round: newRound))
                    showNewRoundSheet = false
                }
            }
            .presentationDetents([.fraction(0.3), .medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    let storeModel = StoreModel.mock
    @ObservedObject var navManager = NavManager()
    @ObservedObject var alertManager = AlertManager()

    return NavigationStack(path: $navManager.tuningPath) {
        TuningScreen()
    }
    .preferredColorScheme(.dark)
    .environmentObject(storeModel)
    .environmentObject(navManager)
    .environmentObject(alertManager)
}
