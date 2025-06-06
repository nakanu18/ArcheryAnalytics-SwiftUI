//
//  RoundEditorScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

struct RoundEditorScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @EnvironmentObject private var alertManager: AlertManager
    @State var round: Round
    @State private var showTargetView = false
    @State private var selectedStageIndex = 0
    @State private var selectedEndIndex = -1
    @State private var isLocked = true
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
        let arrowHoles = selectedEndIndex == selectedStage.numberOfEnds ?
            selectedStage.arrowHoles :
            selectedStage.arrowHoles(endID: selectedEndIndex)
        groupAnalyzer = GroupAnalyzer(arrowHoles: arrowHoles)
    }
    
    private func onEndSelect(stageIndex: Int, endIndex: Int) {
        showTargetView = true
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
        selectedEndIndex = min(selectedEndIndex + 1, selectedStage.numberOfEnds - 1)
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
                targetFaceType: selectedStage.targetFaceType,
                arrowHoles: selectedEndIndex == selectedStage.numberOfEnds ?
                    selectedStage.arrowHoles :
                    selectedStage.arrowHoles(endID: selectedEndIndex),
                targetWidth: Double(selectedStage.targetSize),
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
                }
                ForEach(0 ..< round.stages.count, id: \.self) { stageIndex in
                    let currStage = round.stages[stageIndex]
                    
                    Section("Stage \(stageIndex + 1): \(currStage.distance)m - \(currStage.targetSize)cm") {
                        ForEach(0 ..< currStage.numberOfEnds, id: \.self) { endIndex in
                            let isSelected = selectedStageIndex == stageIndex && selectedEndIndex == endIndex
                            EndCell(stage: currStage, endIndex: endIndex, isSelected: isSelected) {
                                onEndSelect(stageIndex: stageIndex, endIndex: endIndex)
                            }
                        }
                        if currStage.numberOfEnds > 1 {
                            let isSelected = selectedStageIndex == stageIndex && selectedEndIndex == currStage.numberOfEnds
                            TotalCell(stage: currStage, isSelected: isSelected) {
                                onEndSelect(stageIndex: stageIndex, endIndex: currStage.numberOfEnds)
                            }
                        }
                    }
                }
            }
            if showTargetView {
                VStack {
                    renderTarget()
                    renderButtons()
                }
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            if !round.isFinished {
                selectedEndIndex = round.stages[0].firstUnfinishedEndID
                isLocked = false
                showTargetView = true
            }
            resetGroupAnalyzer()
        }
        .onDisappear {
            storeModel.updateRound(round: round)
            storeModel.saveData {
                alertManager.showToast(message: $0, spinner: true)
            } onFail: {
                alertManager.showToast(message: $0, spinner: true)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Target View") {
                    showTargetView = !showTargetView
                    if !showTargetView {
                        selectedEndIndex = -1
                    }
                }
                .disabled(!showTargetView)
            }
        }
        .animation(.easeInOut, value: showTargetView)
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
        ListCell(onTap: nil) {
            HStack {
                Text(key)
                Spacer()
                Text(value)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}

struct EndCell: View {
    let stage: Stage
    let endIndex: Int
    let isSelected: Bool
    let onRowTap: (() -> Void)?
    let arrowValueSize = 28.0

    var arrowIDs: (start: Int, end: Int) {
        stage.arrowIDs(endID: endIndex)
    }

    var body: some View {
        ListCell(onTap: onRowTap) {
            HStack {
                Text("\(endIndex + 1)")
                    .frame(width: 34, height: 34)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .padding(.trailing, 8)

                ForEach(stage.arrowHoles[arrowIDs.start ..< arrowIDs.end]) { arrowHole in
                    if arrowHole.value >= 0 {
                        let isX = !stage.xPlusOne && arrowHole.value > stage.targetFaceType.numberOfRings
                        ZStack {
                            Text(isX ? "X" : "\(arrowHole.value)")
                                .frame(width: arrowValueSize, height: arrowValueSize)
                                .background(stage.targetFaceType.ringColors(value: arrowHole.value))
                                .foregroundColor(stage.targetFaceType.valueTextColor(value: arrowHole.value))
                                .cornerRadius(20)
                            Circle()
                                .stroke(.black, lineWidth: 2)
                                .frame(width: arrowValueSize, height: arrowValueSize)
                        }
                    }
                }

                Spacer()
                Text("\(stage.score(endID: endIndex))")
                    .foregroundColor(isSelected ? .black : .white)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(isSelected ? .green : Color.clear)
    //        .overlay(
    //            RoundedRectangle(cornerRadius: 8)
    //                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
    //        )
        }
    }
}

struct TotalCell: View {
    let stage: Stage
    let isSelected: Bool
    let onRowTap: (() -> Void)?

    var body: some View {
        ListCell(onTap: onRowTap) {
            HStack {
                Text("Total")
                    .padding(.horizontal, 10)
                    .frame(height: 34)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                Spacer()
                Text("\(stage.totalScore)")
                    .foregroundColor(isSelected ? .black : .white)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(isSelected ? .green : Color.clear)
        }
    }
}
