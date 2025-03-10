//
//  RoundEditorScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundEditorScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @State private var selectedEndID = 0
    var roundID: UUID

    private var round: Round {
        guard let foundRound = storeModel.rounds.first(where: { $0.id == roundID }) else {
            fatalError("Round not found")
        }
        return foundRound
    }

    private func onEndSelect(index: Int) {
        selectedEndID = index
    }

    private func onArrowHoleScored(arrowHole: ArrowHole) {
        storeModel.updateArrowHole(roundID: roundID, endID: selectedEndID, arrowHole: arrowHole)
    }

    private func onRemoveLastArrow() {
        storeModel.clearLastMarkedArrowHole(roundID: roundID, endID: selectedEndID)
    }

    private func onNextEnd() {
        selectedEndID = min(selectedEndID + 1, round.numberOfEnds - 1)
    }

    var body: some View {
        VStack {
            List {
                Section("Info") {
                    Text("Round Stuff")
                }
                Section("Ends") {
                    ForEach(0 ..< round.numberOfEnds, id: \.self) { index in
                        EndCell(round: round, endID: index, isSelected: selectedEndID == index)
                            .onTapGesture {
                                onEndSelect(index: index)
                            }
                    }
                }
            }
            TargetDetectorView(arrowHoles: round.arrowHoles(endID: selectedEndID),
                               scale: 9.0,
                               onTargetTap: onArrowHoleScored)
            HStack {
                Button("Delete Last Arrow", action: onRemoveLastArrow)
                    .padding(.horizontal, 20)
                Button("Next End", action: onNextEnd)
                    .padding(.horizontal, 20)
            }
        }
        .onAppear {
            if !round.isFinished {
                selectedEndID = round.firstUnfinishedEndID
            }
        }
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    var roundID = storeModel.rounds[0].id
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.path) {
        RoundEditorScreen(roundID: roundID)
            .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
    }.preferredColorScheme(.dark)
        .environmentObject(storeModel)
        .environmentObject(navManager)
}

struct EndCell: View {
    let round: Round
    let endID: Int
    var isSelected: Bool

    var arrowIDs: (start: Int, end: Int) {
        round.arrowIDs(endID: endID)
    }

    var body: some View {
        HStack {
            Text("\(endID + 1)")
                .frame(width: 30, height: 30)
                .background(.black)
                .foregroundColor(.gray)
                .cornerRadius(6)
                .padding(.trailing, 8)

            ForEach(round.arrowHoles[arrowIDs.start ..< arrowIDs.end]) { arrowHole in
                if arrowHole.value >= 0 {
                    ArrowHoleView(value: arrowHole.value)
//                        .id(numberWrapper.id) // TODO: is this needed?
                }
            }

            Spacer()
            Text("\(round.score(endID: endID))")
                .foregroundColor(.black)
                .padding(.trailing, 4)
        }
        .padding(1)
        .background(isSelected ? .green : .black)
        .cornerRadius(6)
    }
}

struct ArrowHoleView: View {
    let value: Int

    let bgColor: [Color] = [.white, .white, .white, .black, .black, .blue, .blue, .red, .red, .yellow, .yellow, .yellow]
    let color: [Color] = [.black, .black, .black, .white, .white, .white, .white, .white, .white, .black, .black, .red]

    var body: some View {
        ZStack {
            Text("\(value)")
                .frame(width: 28, height: 28)
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
