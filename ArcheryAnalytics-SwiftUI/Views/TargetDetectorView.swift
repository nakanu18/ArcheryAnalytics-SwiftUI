//
//  TargetDetectorView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/27/23.
//

import SwiftUI

struct TargetDetectorView: View {
    var targetFaceType: TargetFaceType
    var arrowHoles: [ArrowHole]

    var targetWidth: Double
    var groupAnalyzer: GroupAnalyzer
    let padding = 20.0

    // 0.540cm -> 0.214" - VAP
    // 0.714cm -> 0.281" - 18/64
    // 0.912cm -> 0.359" - 23/64
    let arrowHoleRadius = 0.175
//    let arrowHoleRadius = 0.540 / 2
//    let arrowHoleRadius = 0.714 / 2
//    let arrowHoleRadius = 0.912 / 2
//    let arrowHoleRadius = 1.19 / 2

    var onTargetTap: ((ArrowHole) -> Void)?

    init(targetFaceType: TargetFaceType, arrowHoles: [ArrowHole], targetWidth: Double, groupAnalyzer: GroupAnalyzer, onTargetTap: ((ArrowHole) -> Void)?) {
        self.targetFaceType = targetFaceType
        self.arrowHoles = arrowHoles
//        self.targetWidth = targetWidth
        self.targetWidth = 20
        self.groupAnalyzer = groupAnalyzer
        self.onTargetTap = onTargetTap
    }
    
    var scale: Double {
        // Given 40cm with 8x, calc the ratio of this target
        (40 * 8) / targetWidth
    }
    
    var frameSize: Double {
        scale * targetWidth
    }
    
    func addArrowHole(location: CGPoint) {
        // Tap relative to the center of the target
        let pt = CGPointMake(location.x - padding - frameSize / 2, location.y - padding - frameSize / 2)

        // Calculate the distance from center for the ring hit
        let dist = sqrt(pt.x * pt.x + pt.y * pt.y)

        // Calculate the scaled down pt. if targetWidth = 10, -5 to 5 in both x and y
        let downscaledPt = CGPointMake(pt.x / scale, pt.y / scale)
        let downscaledDist = dist / scale

        // Calculate which ring was hit
        let ringWidth = (targetWidth / 2.0) / Double(targetFaceType.numberOfRings)
        let ring = targetFaceType.numberOfRings - Int((downscaledDist - arrowHoleRadius) / ringWidth)
        
        print("- Tap: \(location.toString) -> \(downscaledPt.toString), DIST: \(String(format: "%.2f", downscaledDist)), RING: \(ring)")

        var arrowHole = ArrowHole()
        arrowHole.point = downscaledPt
        arrowHole.value = ring
        onTargetTap?(arrowHole)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack() {
                TargetView(targetFaceType: targetFaceType, scale: scale, targetWidth: targetWidth)
                    .frame(width: frameSize + padding * 2, height: frameSize + padding * 2)
                    .background(Color(red: 0.75, green: 0.75, blue: 0.75))
                    .onTapGesture(coordinateSpace: .local) { location in
                        addArrowHole(location: location)
                    }
                ArrowPlotView(arrowHoles: arrowHoles, groupAnalyzer: groupAnalyzer, isShadowEnabled: true, scale: scale, arrowHoleRadius: arrowHoleRadius)
            }
            Text("\(Int(targetWidth))cm")
                .padding([.bottom, .trailing], 10)
        }
    }
}

#Preview {
    @Previewable @State var arrowHoles: [ArrowHole] = []
    @Previewable @State var groups: [CGSize] = []
    
    var groupAnalyzer: GroupAnalyzer {
        GroupAnalyzer(arrowHoles: arrowHoles)
    }

    return TargetDetectorView(targetFaceType: .gold, arrowHoles: arrowHoles, targetWidth: 40, groupAnalyzer: groupAnalyzer) { arrowHole in
        arrowHoles.append(arrowHole)
    }
}

struct TargetView: View {
    let targetFaceType: TargetFaceType
    let scale: Double
    let targetWidth: Double

    func ringWidth(index: Int) -> CGFloat {
        let width = targetWidth - targetFaceType.ringToRingDistance(targetWidth: targetWidth) * Double(index)
        return CGFloat(scale * width)
    }

    var body: some View {
        ZStack {
            ForEach(0 ..< targetFaceType.numberOfRings, id: \.self) { index in
                Circle()
                    .stroke(targetFaceType.targetLineColor, lineWidth: 1)
                    .background(Circle().fill(targetFaceType.ringColors(value: 1 + index)))
                    .frame(width: ringWidth(index: index))
            }
            // Draw center ring - half size of normal ring
            Circle()
                .stroke(targetFaceType.targetLineColor, lineWidth: 1)
                .background(Circle().fill(targetFaceType.ringColors(value: 1 + targetFaceType.numberOfRings - 1)))
                .frame(width: ringWidth(index: targetFaceType.numberOfRings - 1) / 2)
        }
    }
}

struct ArrowPlotView: View {
    var arrowHoles: [ArrowHole]
    var groupAnalyzer: GroupAnalyzer
    var isShadowEnabled: Bool
    var scale: Double
    var arrowHoleRadius: Double
    
    var arrowHoleDiameter: Double {
        scale * arrowHoleRadius * 2
    }

    var body: some View {
        if groupAnalyzer.numOfFinishedArrows >= 3 {
            Group {
                Ellipse()
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    .fill(Color.black.opacity(0.2))
                    .frame(width: groupAnalyzer.size.width * scale,
                           height: groupAnalyzer.size.height * scale)
                Rectangle()
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: 1, height: 1 * scale)
                Rectangle()
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: 1 * scale, height: 1)
            }
            .offset(x: groupAnalyzer.center.x * scale,
                    y: groupAnalyzer.center.y * scale)
            .allowsHitTesting(false)
        }
        ForEach(arrowHoles) { hole in
            if let holePoint = hole.point {
                if isShadowEnabled {
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .position(holePoint
                            .scaleBy(scale)
                            .shiftBy(CGPoint(x: arrowHoleDiameter, y: arrowHoleDiameter)))
                        .frame(width: arrowHoleDiameter * 2, height: arrowHoleDiameter * 2)
                }
                Circle()
                    .stroke(.white, lineWidth: 0.5)
                    .background(Circle().fill(.black))
                    .position(holePoint
                        .scaleBy(scale)
                        .shiftBy(CGPoint(x: arrowHoleDiameter / 2, y: arrowHoleDiameter / 2)))
                    .frame(width: arrowHoleDiameter, height: arrowHoleDiameter)
            }
        }
    }
}
