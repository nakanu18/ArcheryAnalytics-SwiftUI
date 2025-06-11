//
//  RoundsScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundsScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @EnvironmentObject private var navManager: NavManager
    @EnvironmentObject private var alertManager: AlertManager
    @State private var showNewRoundSheet = false

    private func saveDataToMainFile(showMessage: Bool) {
        storeModel.saveData(newFileName: StoreModel.mainFileName) {
            alertManager.showToast(message: showMessage ? $0 : "", spinner: true)
        } onFail: {
            alertManager.showToast(message: showMessage ? $0 : "", spinner: true)
        }
    }

    var body: some View {
        List {
            Section("Info") {
                KeyValueCell(key: "File Name", value: "\(storeModel.fileName)")
                if storeModel.fileName != StoreModel.mainFileName {
                    ButtonCell(title: "Overwrite to \(StoreModel.mainFileName) file") {
                        alertManager.showConfirmation(confirmationTitle: "Are you sure?",
                                                      confirmMessage: "Overwrite Existing Data",
                                                      cancelMessage: "Cancel",
                                                      onConfirmTap: {
                            saveDataToMainFile(showMessage: true)
                        })
                    }
                }
            }

            Section("Rounds") {
                ForEach(storeModel.rounds) { round in
                    RoundCell(round: round) {
                        navManager.push(route: .roundEditor(round: round))
                    }
                }
                .onDelete { offsets in
                    storeModel.rounds.remove(atOffsets: offsets)
                }
            }
        }
        .navigationTitle("Rounds")
        .toolbar {
#if DEBUG
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    storeModel.printData()
                } label: {
                    Image(systemName: "printer")
                }
                .foregroundColor(.dvDebug)
            }
#endif
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
                Button("WA 18m Round - 300") {
                    let newRound = storeModel.createNewRound(roundType: .vegasRound)
                    navManager.push(route: .roundEditor(round: newRound))
                    showNewRoundSheet = false
                }
                Button("WA 50m Round - 360") {
                    let newRound = storeModel.createNewRound(roundType: .outdoorRound(distance: 50))
                    navManager.push(route: .roundEditor(round: newRound))
                    showNewRoundSheet = false
                }
                Button("Field Round - 360") {
                    let newRound = storeModel.createNewRound(roundType: .fieldRoundFlat)
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

    return NavigationStack(path: $navManager.roundsPath) {
        RoundsScreen()
    }
    .preferredColorScheme(.dark)
    .environmentObject(storeModel)
    .environmentObject(navManager)
    .environmentObject(alertManager)
}

struct RoundCell: View {
    let round: Round
    let onRowTap: (() -> Void)?
    
    var body: some View {
        ListCell(onTap: onRowTap) {
            HStack {
                Rectangle()
                    .fill(!round.isFinished ? Color.green : Color.clear)
                    .frame(width: 6)
                    .padding(.trailing, 6)
                VStack(alignment: .leading) {
                    Text("\(round.name)")
                        .foregroundColor(.orange)
                        .fontWeight(.bold)
                    Text(round.date, formatter: DateFormatter.shortFormatter)
                        .font(.caption)
                }
                Spacer()
                HStack {
                    Text("\(round.totalScore)")
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .padding(.trailing, 12)
                }
            }
            .frame(height: 60)
        }
    }
}
