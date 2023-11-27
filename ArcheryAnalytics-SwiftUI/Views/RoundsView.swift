//
//  ContentView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundsView: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    
    var body: some View {
        NavigationView {
            List {
                Section("Info") {
                    Text("Total Rounds: \(storeModel.rounds.count)")
                }

                Section("Rounds") {
                    ForEach(storeModel.rounds) { round in
                        NavigationLink(destination: RoundEditorView(roundID: round.id)) {
                            HStack {
                                Text("ID: \(round.id)")
                                Spacer()
                                Text("\(round.totalScore)")
                            }
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    RoundsView()
        .environmentObject(StoreModel.mock)
}
