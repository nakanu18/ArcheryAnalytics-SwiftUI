//
//  RoundView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundEditorView: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    var roundID: Int
    
    var round: Round {
        // TODO should use findIndex
        storeModel.rounds[roundID]
    }
    
    var body: some View {
        List {
            Section("Info") {
                Text("Round Stuff")
            }

            Section("Ends") {
                ForEach(0..<round.numberOfEnds) { index in
                    EndCell(endID: index, endValues: round.end(index))
                }
            }
        }
    }
    
}

#Preview {
    RoundEditorView(roundID: 0)
        .environmentObject(StoreModel.mock)
}

struct EndCell: View {
    let endID: Int
    let endValues: [Int]
        
    var body: some View {
        HStack {
            Text("\(endID + 1):")
                .padding(.trailing)
            
            
            ForEach(endValues.map(NumberWrapper.init)) { numberWrapper in
                Text("\(numberWrapper.number)")
                    .id(numberWrapper.id)
            }
            
            Spacer()
            Text("7")
        }
    }
}

struct NumberWrapper: Identifiable {
    let id = UUID()
    let number: Int
}
