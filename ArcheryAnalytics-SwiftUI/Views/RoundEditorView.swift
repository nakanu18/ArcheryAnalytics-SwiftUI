//
//  RoundView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundEditorView: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    @State var arrowHoles: [ArrowHole] = []
    @State var selectedEndID = -1
    
    private var selectedRound: Round {
        storeModel.selectedRound
    }
    
    private var selectedEnd: End? {
        storeModel.selectedRound.ends[selectedEndID]
    }
    
    private func onArrowHoleScored() {
        
    }
    
    private func onRemoveLastArrow() {
        if !arrowHoles.isEmpty {
            arrowHoles.removeLast()
        }
    }
    
    private func onNextEnd() {
    }
    
    var body: some View {
        VStack {
            List {
                Section("Info") {
                    Text("Round Stuff")
                }

                Section("Ends") {
                    ForEach(0..<selectedRound.ends.count) { index in
                        EndCell(i: index, end: selectedRound.ends[index], isSelected: selectedEndID == index)
                            .onTapGesture {
                                selectedEndID = index
                            }
                    }
                }
            }
            TargetDetectorView(arrowHoles: $arrowHoles, scale: 9.0)
            HStack {
                Button("Delete Last Arrow", action: onRemoveLastArrow)
                    .padding(.horizontal, 20)
                Button("Next End", action: onNextEnd)
                    .padding(.horizontal, 20)
            }
        }
        .onAppear {
            if (!selectedRound.isFinished) {
                selectedEndID = selectedRound.unfinishedEndID
            }
        }
    }
    
}

#Preview {
    RoundEditorView()
        .environmentObject(StoreModel.mockEmpty)
}

struct EndCell: View {
    let i: Int
    let end: End
    var isSelected: Bool
        
    var body: some View {
        HStack {
            Text("\(i + 1)")
                .frame(width: 30, height: 30)
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(6)
                .padding(.trailing, 8)
            
            ForEach(end.arrowValues.map(NumberWrapper.init)) { numberWrapper in
                if (numberWrapper.number >= 0) {
                    ArrowHoleView(value: numberWrapper.number)
                        .id(numberWrapper.id)
                }
            }
            
            Spacer()
            Text("\(end.totalScore)")
        }
        .padding(4)
        .background(isSelected ? Color(red: 0.0, green: 1.0, blue: 0.0) : .white)
        .cornerRadius(6)
    }
}

struct NumberWrapper: Identifiable {
    let id = UUID()
    let number: Int
}

struct ArrowHoleView: View {
    let value: Int
    
    let bgColor: [Color] = [.white, .white, .white, .black, .black, .blue,  .blue,  .red,   .red,  .yellow, .yellow, .yellow]
    let color: [Color] =   [.black, .black, .black, .white, .white, .white, .white, .white, .white, .black, .black,  .red]

    var body: some View {
        ZStack {
            Text("\(value)")
                .frame(width: 24, height: 24)
                .background(bgColor[value])
                .foregroundColor(color[value])
                .cornerRadius(20)
                .padding(.horizontal, 3)
            Circle()
                .stroke(Color.gray, lineWidth: 2)
                .frame(width: 28, height: 28)
        }
    }
}
