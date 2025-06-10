//
//  TargetControlView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/9/25.
//

import SwiftUI

struct TargetControlView: View {
    var selectedStage: Stage
    @Binding var selectedEndIndex: Int
    @Binding var isLocked: Bool
    @Binding var groupAnalyzer: GroupAnalyzer

    var onArrowHoleScored: (ArrowHole) -> Void
    var onRemoveLastArrow: () -> Void
    var onNextEnd: () -> Void

    // Used for panning and zooming
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero
    @GestureState private var gestureScale: CGFloat = 1.0

    //
    // MARK: - Renders
    //

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
            Button("Re-center") {
                scale = 1.0
                offset = .zero
            }
            Spacer()
            Button("Delete Last", action: onRemoveLastArrow)
                .disabled(isLocked)
            Spacer()
            if !isLocked {
                selectedStage.isFinished
                    ? Button("Lock") { isLocked = true }
                    : Button("Next End", action: onNextEnd)
            } else {
                Button("Unlock") { isLocked = false }
            }
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        VStack {
            renderTarget()
            renderButtons()
        }
        .transition(.move(edge: .bottom))
    }
}
