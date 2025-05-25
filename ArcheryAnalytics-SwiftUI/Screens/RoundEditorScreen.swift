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
    @State private var selectedEndID = 0
    @State private var isLocked = false

    // Used for panning and zooming
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero
    @GestureState private var gestureScale: CGFloat = 1.0
    
    private func onEndSelect(index: Int) {
        selectedEndID = index
    }

    private func onArrowHoleScored(arrowHole: ArrowHole) {
        round.targetGroups[0].updateFirstUnmarkedArrowHole(endID: selectedEndID, arrowHole: arrowHole)
    }

    private func onRemoveLastArrow() {
        round.targetGroups[0].clearLastMarkedArrowHole(endID: selectedEndID)
    }
    
    private func onRecenter() {
        scale = 1.0
        offset = .zero
    }

    private func onNextEnd() {
        selectedEndID = min(selectedEndID + 1, round.targetGroups[0].numberOfEnds - 1)
    }
    
    private func calcLeftAndRightHoles(arrowHoles: [ArrowHole]) -> (left: CGPoint, right: CGPoint) {
        // Extract only the non-nil CGPoint values from the ArrowHole array.
        let validPoints = arrowHoles.compactMap { $0.point }

        // Handle the edge case where no valid points are found after compactMap.
        guard !validPoints.isEmpty else {
            print("Warning: The input array of ArrowHoles contains no valid (non-nil) points. Returning (0.0, 0.0).")
            return (left: CGPoint(x: 0.0, y: 0.0), right: CGPoint(x: 0.0, y: 0.0))
        }

        // Find the point with the minimum x-coordinate.
        let minXPoint = validPoints.min(by: { $0.x < $1.x })! // '!' is safe due to guard above
        // Find the point with the maximum x-coordinate.
        let maxXPoint = validPoints.max(by: { $0.x < $1.x })!
        
        return (left: minXPoint, right: maxXPoint)
    }
    
    private func calculateGroupDimensions(arrowHoles: [ArrowHole]) -> (width: CGFloat, height: CGFloat) {
        // Extract only the non-nil CGPoint values from the ArrowHole array.
        let validPoints = arrowHoles.compactMap { $0.point }

        // Handle the edge case where no valid points are found after compactMap.
        guard !validPoints.isEmpty else {
            print("Warning: The input array of ArrowHoles contains no valid (non-nil) points. Returning (0.0, 0.0).")
            return (width: 0.0, height: 0.0)
        }

        // Find the point with the minimum x-coordinate.
        let minXPoint = validPoints.min(by: { $0.x < $1.x })! // '!' is safe due to guard above
        // Find the point with the maximum x-coordinate.
        let maxXPoint = validPoints.max(by: { $0.x < $1.x })!

        // Find the point with the minimum y-coordinate.
        let minYPoint = validPoints.min(by: { $0.y < $1.y })!
        // Find the point with the maximum y-coordinate.
        let maxYPoint = validPoints.max(by: { $0.y < $1.y })!

        // Calculate the width and height using the found min/max coordinates.
        let width = maxXPoint.x - minXPoint.x
        let height = maxYPoint.y - minYPoint.y

        return (width: width, height: height)
    }
    
    private func renderTarget() -> some View {
        GeometryReader { proxy in
            TargetDetectorView(
                arrowHoles: selectedEndID == round.targetGroups[0].numberOfEnds ?
                    round.targetGroups[0].arrowHoles :
                    round.targetGroups[0].arrowHoles(endID: selectedEndID),
                targetWidth: Double(round.targetGroups[0].targetSize),
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
            .clipped() // ⬅️ prevents overflowing outside of the frame
            .contentShape(Rectangle()) // makes gestures work properly
        }
    }

    var body: some View {
        VStack {
            List {
                Section("Info") {
                    KeyValueCell(key: "Name", value: round.name)
                    KeyValueCell(key: "refCode", value: round.refCode())
                }
                Section("List") {
                    KeyValueCell(key: "refCode", value: round.targetGroups[0].refCode())
//                    KeyValueCell(key: "left", value: calcLeftAndRightHoles(arrowHoles: round.targetGroups[0].arrowHoles).left.toString)
//                    KeyValueCell(key: "right", value: calcLeftAndRightHoles(arrowHoles: round.targetGroups[0].arrowHoles).right.toString)
//                    KeyValueCell(key: "width", value: "\(calculateGroupDimensions(arrowHoles: round.targetGroups[0].arrowHoles).width)")
//                    KeyValueCell(key: "height", value: "\(calculateGroupDimensions(arrowHoles: round.targetGroups[0].arrowHoles).height)")
                    ForEach(0 ..< round.targetGroups[0].numberOfEnds, id: \.self) { index in
                        EndCell(round: round, endID: index, isSelected: selectedEndID == index)
                            .onTapGesture {
                                onEndSelect(index: index)
                            }
                    }
                    TotalCell(round: round, isSelected: selectedEndID == round.targetGroups[0].numberOfEnds)
                        .onTapGesture {
                            onEndSelect(index: round.targetGroups[0].numberOfEnds)
                        }
                }
            }

            renderTarget()
            HStack {
                Button("Re-center", action: onRecenter)
                Spacer()
                Button("Delete Last", action: onRemoveLastArrow)
                    .disabled(isLocked)
                Spacer()
                if !isLocked {
                    if round.targetGroups[0].isFinished {
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
        .onAppear {
            if !round.isFinished {
                selectedEndID = round.targetGroups[0].firstUnfinishedEndID
                isLocked = false
            } else {
                selectedEndID = round.targetGroups[0].numberOfEnds
                isLocked = true
            }
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
    let endID: Int
    let isSelected: Bool

    var arrowIDs: (start: Int, end: Int) {
        round.targetGroups[0].arrowIDs(endID: endID)
    }

    var body: some View {
        HStack {
            Text("\(endID + 1)")
                .frame(width: 30, height: 30)
                .background(.black)
                .foregroundColor(.gray)
                .cornerRadius(6)
                .padding(.trailing, 8)

            ForEach(round.targetGroups[0].arrowHoles[arrowIDs.start ..< arrowIDs.end]) { arrowHole in
                if arrowHole.value >= 0 {
                    ArrowHoleView(value: arrowHole.value)
//                        .id(numberWrapper.id) // TODO: is this needed?
                }
            }

            Spacer()
            Text("\(round.targetGroups[0].score(endID: endID))")
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
            Text("\(round.targetGroups[0].totalScore)")
                .foregroundColor(isSelected ? .black : .white)
                .padding(.trailing, 4)
        }
        .padding(1)
        .background(isSelected ? .green : .black)
        .cornerRadius(6)
    }
}
