//
//  RoundEditorScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundEditorScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @State var round: Round
    @State private var selectedStageIndex = 0
    @State private var selectedEndIndex = 0
    @State private var isLocked = false
    @State private var groupAnalyzer = GroupAnalyzer(arrowHoles: [])

    // Used for panning and zooming
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero
    @GestureState private var gestureScale: CGFloat = 1.0
    
    private var selectedStage: Stage {
        round.stages[selectedStageIndex]
    }
    
    private func resetGroupAnalyzer() {
        let arrowHoles = selectedEndIndex == round.stages[selectedStageIndex].numberOfEnds ?
            round.stages[selectedStageIndex].arrowHoles :
            round.stages[selectedStageIndex].arrowHoles(endID: selectedEndIndex)
        groupAnalyzer = GroupAnalyzer(arrowHoles: arrowHoles)
    }
    
    private func onEndSelect(stageIndex: Int, endIndex: Int) {
        selectedStageIndex = stageIndex
        selectedEndIndex = endIndex
        resetGroupAnalyzer()
    }

    private func onArrowHoleScored(arrowHole: ArrowHole) {
        round.stages[selectedStageIndex].updateFirstUnmarkedArrowHole(endID: selectedEndIndex, arrowHole: arrowHole)
        resetGroupAnalyzer()
    }

    private func onRemoveLastArrow() {
        round.stages[selectedStageIndex].clearLastMarkedArrowHole(endID: selectedEndIndex)
        resetGroupAnalyzer()
    }
    
    private func onRecenter() {
        scale = 1.0
        offset = .zero
    }

    private func onNextEnd() {
        selectedEndIndex = min(selectedEndIndex + 1, round.stages[selectedStageIndex].numberOfEnds - 1)
        resetGroupAnalyzer()
    }
    
    private func renderAnalysis() -> some View {
        Group {
            let groups = groupAnalyzer.groups
            if groups.count >= 1 {
                KeyValueCell(key: "Group W", value: "\(groups[0].width.toString())")
            }
            if groups.count >= 2 {
                KeyValueCell(key: "Group W-1", value: "\(groups[1].width.toString())")
            }
            if groups.count >= 3 {
                KeyValueCell(key: "Group W-2", value: "\(groups[2].width.toString())")
            }
            if groups.count >= 1 {
                KeyValueCell(key: "Group H", value: "\(groups[0].height.toString())")
            }
            if groups.count >= 2 {
                KeyValueCell(key: "Group H-1", value: "\(groups[1].height.toString())")
            }
            if groups.count >= 3 {
                KeyValueCell(key: "Group H-2", value: "\(groups[2].height.toString())")
            }

        }
    }

    private func renderTarget() -> some View {
        GeometryReader { proxy in
            TargetDetectorView(
                arrowHoles: selectedEndIndex == round.stages[selectedStageIndex].numberOfEnds ?
                    round.stages[selectedStageIndex].arrowHoles :
                    round.stages[selectedStageIndex].arrowHoles(endID: selectedEndIndex),
                targetWidth: Double(round.stages[selectedStageIndex].targetSize),
                groupAnalyzer: groupAnalyzer,
                onTargetTap: onArrowHoleScored
            )
            .disabled(isLocked)
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
            .clipped()
            .contentShape(Rectangle()) // makes gestures work properly
        }
    }
    
    private func renderButtons() -> some View {
        HStack {
            Button("Re-center", action: onRecenter)
            Spacer()
            Button("Delete Last", action: onRemoveLastArrow)
                .disabled(isLocked)
            Spacer()
            if !isLocked {
                if round.stages[0].isFinished {
                    Button("Lock") {
                        isLocked = true
                    }
                } else {
                    Button("Next End", action: onNextEnd)
                }
            } else {
                Button("Unlock") {
                    isLocked = false
                }
            }
        }
        .padding(.horizontal)
    }

    var body: some View {
        VStack {
            List {
                Section("Overview") {
                    KeyValueCell(key: "Name", value: round.name)
                    KeyValueCell(key: "Number of Arrows", value: "\(round.totalNumberOfArrowsShot) / \(round.totalNumberOfArrows)")
                    KeyValueCell(key: "Total Score", value: "\(round.totalScore)")
//                    KeyValueCell(key: "refCode", value: round.refCode())
                }
                ForEach(0 ..< round.stages.count, id: \.self) { stageIndex in
                    Section("Stage \(stageIndex + 1): \(round.stages[stageIndex].distance)m - \(round.stages[stageIndex].targetSize)cm") {
//                        KeyValueCell(key: "refCode", value: round.stages[stageIndex].refCode())
                        ForEach(0 ..< round.stages[stageIndex].numberOfEnds, id: \.self) { endIndex in
                            EndCell(round: round, stageIndex: stageIndex, endIndex: endIndex, isSelected: selectedStageIndex == stageIndex && selectedEndIndex == endIndex)
                                .onTapGesture {
                                    onEndSelect(stageIndex: stageIndex, endIndex: endIndex)
                                }
                        }
                        TotalCell(round: round, stageIndex: stageIndex, isSelected: selectedStageIndex == stageIndex && selectedEndIndex == round.stages[stageIndex].numberOfEnds)
                            .onTapGesture {
                                onEndSelect(stageIndex: stageIndex, endIndex: round.stages[stageIndex].numberOfEnds)
                            }
                    }
                }
            }
            renderTarget()
            renderButtons()
        }
        .onAppear {
            if !round.isFinished {
                selectedEndIndex = round.stages[0].firstUnfinishedEndID
                isLocked = false
            } else {
                selectedEndIndex = round.stages[0].numberOfEnds
                isLocked = true
            }
            resetGroupAnalyzer()
        }
        .onDisappear {
            storeModel.updateRound(round: round)
            storeModel.saveData()
        }
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.path) {
        RoundEditorScreen(round: storeModel.rounds[0])
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
    let stageIndex: Int
    let endIndex: Int
    let isSelected: Bool

    var arrowIDs: (start: Int, end: Int) {
        round.stages[stageIndex].arrowIDs(endID: endIndex)
    }

    var body: some View {
        HStack {
            Text("\(endIndex + 1)")
                .frame(width: 34, height: 34)
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(6)
                .padding(.trailing, 8)

            ForEach(round.stages[stageIndex].arrowHoles[arrowIDs.start ..< arrowIDs.end]) { arrowHole in
                if arrowHole.value >= 0 {
                    ArrowHoleView(value: arrowHole.value)
                }
            }

            Spacer()
            Text("\(round.stages[stageIndex].score(endID: endIndex))")
                .foregroundColor(isSelected ? .black : .white)
                .padding(.trailing, 4)
        }
        .padding(2)
        .contentShape(Rectangle())
        .background(isSelected ? .green : Color.clear)
        .cornerRadius(6)
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
//        )
    }
}

struct ArrowHoleView: View {
    let value: Int

    let bgColor: [Color] = [.white, .white, .white, .black, .black, .blue, .blue, .red, .red, .yellow, .yellow, .yellow]
    let color: [Color] = [.black, .black, .black, .white, .white, .white, .white, .white, .white, .black, .black, .red]
    let size = 28.0
    
    var body: some View {
        ZStack {
            Text("\(value)")
                .frame(width: size, height: size)
                .background(bgColor[value])
                .foregroundColor(color[value])
                .cornerRadius(20)
            Circle()
                .stroke(.black, lineWidth: 2)
                .frame(width: size, height: size)
        }
    }
}

struct TotalCell: View {
    let round: Round
    let stageIndex: Int
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text("Total")
                .padding(.horizontal, 10)
                .frame(height: 34)
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(6)
            Spacer()
            Text("\(round.stages[stageIndex].totalScore)")
                .foregroundColor(isSelected ? .black : .white)
                .padding(.trailing, 4)
        }
        .padding(2)
        .contentShape(Rectangle())
        .background(isSelected ? .green : Color.clear)
        .cornerRadius(6)
    }
}
