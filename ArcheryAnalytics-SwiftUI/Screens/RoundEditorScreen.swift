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

    // Used for panning and zooming
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero
    @GestureState private var gestureScale: CGFloat = 1.0
    
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
    
    private func onRecenter() {
        scale = 1.0
        offset = .zero
    }

    private func onNextEnd() {
        selectedEndID = min(selectedEndID + 1, round.currentTargetGroup.numberOfEnds - 1)
    }
    
    var body: some View {
        VStack {
            List {
                Section("Info") {
                    KeyValueCell(key: "Name", value: round.name)
                }
                Section("\(round.currentTargetGroup.distance)m --- \(Int(round.currentTargetGroup.targetSize))cm") {
                    ForEach(0 ..< round.currentTargetGroup.numberOfEnds, id: \.self) { index in
                        EndCell(round: round, endID: index, isSelected: selectedEndID == index)
                            .onTapGesture {
                                onEndSelect(index: index)
                            }
                    }
                    TotalCell(round: round, isSelected: selectedEndID == round.currentTargetGroup.numberOfEnds)
                        .onTapGesture {
                            onEndSelect(index: round.currentTargetGroup.numberOfEnds)
                        }
                }
            }

            GeometryReader { proxy in
                TargetDetectorView(
                    arrowHoles: selectedEndID == round.currentTargetGroup.numberOfEnds ?
                        round.currentTargetGroup.arrowHoles :
                        round.currentTargetGroup.arrowHoles(endID: selectedEndID),
                    scale: 9.0,
                    onTargetTap: onArrowHoleScored
                )
                .scaleEffect(scale * gestureScale)
                .offset(
                    x: offset.width + gestureOffset.width,
                    y: offset.height + gestureOffset.height
                )
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .updating($gestureScale) { val, state, _ in
                                state = val
                            }
                            .onEnded { val in
                                scale *= val
                            },
                        DragGesture()
                            .updating($gestureOffset) { val, state, _ in
                                state = val.translation
                            }
                            .onEnded { val in
                                offset.width += val.translation.width
                                offset.height += val.translation.height
                            }
                    )
                )
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped() // ⬅️ prevents overflowing outside of the frame
                .contentShape(Rectangle()) // makes gestures work properly
            }

            HStack {
                Button("Re-center", action: onRecenter)
                Spacer()
                Button("Delete Last", action: onRemoveLastArrow)
                Spacer()
                Button("Next End", action: onNextEnd)
            }
            .padding(.horizontal)
        }
        .onAppear {
            if !round.isFinished {
                selectedEndID = round.currentTargetGroup.firstUnfinishedEndID
            } else {
                selectedEndID = round.currentTargetGroup.numberOfEnds
            }
        }
        .onDisappear {
            storeModel.saveData()
        }
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    let roundID = storeModel.rounds[0].id
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.path) {
        RoundEditorScreen(roundID: roundID)
            .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
    }.preferredColorScheme(.dark)
        .environmentObject(storeModel)
        .environmentObject(navManager)
}

struct KeyValueCell: View {
    let key: String
    let value: String
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
        }
    }
}

struct EndCell: View {
    let round: Round
    let endID: Int
    let isSelected: Bool

    var arrowIDs: (start: Int, end: Int) {
        round.currentTargetGroup.arrowIDs(endID: endID)
    }

    var body: some View {
        HStack {
            Text("\(endID + 1)")
                .frame(width: 30, height: 30)
                .background(.black)
                .foregroundColor(.gray)
                .cornerRadius(6)
                .padding(.trailing, 8)

            ForEach(round.currentTargetGroup.arrowHoles[arrowIDs.start ..< arrowIDs.end]) { arrowHole in
                if arrowHole.value >= 0 {
                    ArrowHoleView(value: arrowHole.value)
//                        .id(numberWrapper.id) // TODO: is this needed?
                }
            }

            Spacer()
            Text("\(round.currentTargetGroup.score(endID: endID))")
                .foregroundColor(isSelected ? .black : .white)
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
                .frame(width: 26, height: 26)
                .background(bgColor[value])
                .foregroundColor(color[value])
                .cornerRadius(20)
            Circle()
                .stroke(Color.gray, lineWidth: 2)
                .frame(width: 26, height: 26)
        }
    }
}

struct TotalCell: View {
    let round: Round
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text("Total")
                .padding(.horizontal, 4)
                .frame(height: 30)
                .background(.black)
                .foregroundColor(.gray)
                .cornerRadius(6)
            Spacer()
            Text("\(round.currentTargetGroup.totalScore)")
                .foregroundColor(isSelected ? .black : .white)
                .padding(.trailing, 4)
        }
        .padding(1)
        .background(isSelected ? .green : .black)
        .cornerRadius(6)
    }
}
