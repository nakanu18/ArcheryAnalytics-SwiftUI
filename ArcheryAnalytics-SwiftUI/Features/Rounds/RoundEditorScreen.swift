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

    private var selectedStage: Stage {
        round.stages[selectedStageIndex]
    }
    
    //
    // MARK: - Actions
    //
        
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

    private func onNextEnd() {
        selectedEndIndex = min(selectedEndIndex + 1, selectedStage.numberOfEnds - 1)
        resetGroupAnalyzer()
    }

    //
    // MARK: - Renders
    //

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
                TargetControlView(selectedStage: selectedStage,
                                  selectedEndIndex: $selectedEndIndex,
                                  isLocked: $isLocked,
                                  groupAnalyzer: $groupAnalyzer,
                                  onArrowHoleScored: onArrowHoleScored,
                                  onRemoveLastArrow: onRemoveLastArrow,
                                  onNextEnd: onNextEnd)
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
            storeModel.saveData(newFileName: StoreModel.mainFileName) { _ in
                alertManager.showToast(message: "", spinner: true)
            } onFail: { _ in
                alertManager.showToast(message: "", spinner: true)
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
        .toolbar(.hidden, for: .tabBar) // Explicitly hide tab bar
        .animation(.easeInOut, value: showTargetView)
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.roundsPath) {
        RoundEditorScreen(round: storeModel.rounds[0])
    }
    .preferredColorScheme(.dark)
    .environmentObject(storeModel)
    .environmentObject(navManager)
}
