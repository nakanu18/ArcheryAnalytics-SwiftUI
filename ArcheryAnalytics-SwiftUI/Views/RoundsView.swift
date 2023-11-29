//
//  ContentView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundsView: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    @State var test = 0
    @State var lastArrowHole = ArrowHole(id: 0, point: CGPointZero, value: 0)

    var showTargetDetector = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Info") {
                    Text("Total Rounds: \(storeModel.rounds.count)")
                }

                Section("Rounds") {
                    ForEach(storeModel.rounds) { round in
                        if showTargetDetector {
                            NavigationLink(destination: TargetDetectorView(lastArrowHole: $lastArrowHole, scale: 100.0)) {
                                HStack {
                                    Text("ID: \(round.id)")
                                    Spacer()
                                    Text("\(round.totalScore)")
                                }
                            }
                        } else {
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
    
}

#Preview {
    RoundsView()
        .environmentObject(StoreModel.mock)
}
