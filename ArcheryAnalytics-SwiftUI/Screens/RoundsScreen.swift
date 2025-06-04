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
    @State private var showNewRoundSheet = false

    var body: some View {
        List {
            Section("Info") {
                Text("Total Rounds: \(storeModel.rounds.count)")
            }

            Section("Rounds") {
                ForEach(storeModel.rounds) { round in
                    RoundCell(round: round) {
                        navManager.push(route: .roundEditor(round: round))
                    }
                }.onDelete { offsets in
                    storeModel.rounds.remove(atOffsets: offsets)
                }
            }
        }
        .navigationTitle("Rounds")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("+") {
                    showNewRoundSheet = true
                }
            }
        }
        .sheet(
            isPresented: $showNewRoundSheet,
            content: {
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
        )
    }
}

#Preview {
    let storeModel = StoreModel.mock
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.path) {
        RoundsScreen()
            .navigationBarTitleDisplayMode(.inline)  // TODO: temp fix for big space on RoundEditorScreen
    }
    .preferredColorScheme(.dark)
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
                Rectangle()
                    .fill(!round.isFinished ? Color.green : Color.clear)
                    .frame(width: 8)
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
        .listRowInsets(EdgeInsets())
        .foregroundColor(.white)
    }
}
