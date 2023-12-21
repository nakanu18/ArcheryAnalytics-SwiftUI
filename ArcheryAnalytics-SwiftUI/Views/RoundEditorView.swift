//
//  RoundView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundEditorView: View {
    
    @Binding var selectedRound: Round
    @State var selectedEndID = 0
    
    private var selectedEnd: End? {
        if selectedEndID != -1 {
            return selectedRound.ends[selectedEndID]
        }
        return nil
    }
    
    private func onEndSelect(index: Int) {
        selectedEndID = index
    }
    
    private func onArrowHoleScored(arrowHole: ArrowHole) {
        selectedRound.ends[selectedEndID].updateFirstUnmarkedArrowHole(arrowHole: arrowHole)
    }
    
    private func onRemoveLastArrow() {
        selectedRound.ends[selectedEndID].clearLastMarkedArrowHole()
    }
    
    private func onNextEnd() {
        if selectedEndID < selectedRound.ends.count - 1 {
            selectedEndID += 1
        }
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
                                onEndSelect(index: index)
                            }
                    }
                }
            }
            TargetDetectorView(arrowHoles: $selectedRound.ends[selectedEndID].arrowHoles, scale: 9.0, onTargetTap: onArrowHoleScored)
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
    // BUG: can't see arrow holes in preview
    @State var selectedRound = Round.mockEmptyRound
    
    return RoundEditorView(selectedRound: $selectedRound)
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
