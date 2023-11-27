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
                    EndCell(end: round.end(index))
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
    let end: End
        
    var body: some View {
        HStack {
            Text("\(end.id + 1)")
                .frame(width: 30, height: 30)
                .background(.black)
                .foregroundColor(.yellow)
                .cornerRadius(6)
                .padding(.trailing)
            
            ForEach(end.arrowValues.map(NumberWrapper.init)) { numberWrapper in
                ArrowValueView(value: numberWrapper.number)
                    .id(numberWrapper.id)
            }
            
            Spacer()
            Text("\(end.totalScore)")
        }
    }
}

struct NumberWrapper: Identifiable {
    let id = UUID()
    let number: Int
}

struct ArrowValueView: View {
    let value: Int
    
    let bgColor: [Color] = [.white, .white, .white, .black, .black, .blue,  .blue,  .red,   .red,  .yellow, .yellow, .yellow]
    let color: [Color] =   [.black, .black, .black, .white, .white, .white, .white, .white, .white, .black, .black,  .red]

    var body: some View {
        ZStack {
            Text("\(value)")
                .frame(width: 35, height: 35)
                .background(bgColor[value])
                .foregroundColor(color[value])
                .cornerRadius(20)
                .padding(.all, 3)
            Circle()
                .stroke(Color.gray, lineWidth: 2)
                .frame(width: 35, height: 35)
        }
    }
}
