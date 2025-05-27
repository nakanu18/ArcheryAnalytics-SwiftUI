//
//  TargetDetectorView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/27/23.
//

import SwiftUI

struct TargetDetectorView: View {
    var arrowHoles: [ArrowHole]

    var targetWidth: Double
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

    init(arrowHoles: [ArrowHole], targetWidth: Double, onTargetTap: ((ArrowHole) -> Void)?) {
        self.arrowHoles = arrowHoles
//        self.targetWidth = targetWidth
        self.targetWidth = 20
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
        let ringWidth = (targetWidth / 2.0) / 10
        let ring = 10 - Int((downscaledDist - arrowHoleRadius) / ringWidth)

        print("- Tap: \(location.toString) -> \(downscaledPt.toString), DIST: \(String(format: "%.2f", downscaledDist)), RING: \(ring)")

        var arrowHole = ArrowHole()
        arrowHole.point = downscaledPt
        arrowHole.value = ring
        onTargetTap?(arrowHole)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack() {
                TargetView(scale: scale, targetWidth: targetWidth)
                    .frame(width: frameSize + padding * 2, height: frameSize + padding * 2)
                    .background(Color(red: 0.75, green: 0.75, blue: 0.75))
                    .onTapGesture(coordinateSpace: .local) { location in
                        addArrowHole(location: location)
                    }
                ArrowPlotView(arrowHoles: arrowHoles, isShadowEnabled: true, scale: scale, arrowHoleRadius: arrowHoleRadius)
            }
            Text("\(Int(targetWidth))cm")
                .padding([.bottom, .trailing], 10)
        }
    }
}

#Preview {
    // BUG: arrow holes not showing in preview
    @Previewable @State var arrowHoles: [ArrowHole] = []

    return TargetDetectorView(arrowHoles: arrowHoles, targetWidth: 40) { arrowHole in
        arrowHoles.append(arrowHole)
    }
}

struct TargetView: View {
    let bgColor: [Color] = [.white, .white, .black, .black, .blue, .blue, .red, .red, .yellow, .yellow, .yellow]
    let lineColor = Color(red: 0.3, green: 0.3, blue: 0.3)

    let numberOfRings = 10
    let scale: Double
    let targetWidth: Double

    func ringWidth(id: Int) -> CGFloat {
        let ringToRingDist = targetWidth / Double(numberOfRings)
        let width = targetWidth - ringToRingDist * Double(id)
        return CGFloat(scale * width)
    }

    var body: some View {
        ZStack {
            ForEach(0 ..< numberOfRings, id: \.self) { index in
                Circle()
                    .stroke(lineColor, lineWidth: 1)
                    .background(Circle().fill(bgColor[index]))
                    .frame(width: ringWidth(id: index))
                    .onAppear {
//                        print("\(index + 1): \(ringWidth(id: index))")
                    }
            }
        }
    }
}

struct ArrowPlotView: View {
    var arrowHoles: [ArrowHole]
    var isShadowEnabled: Bool
    var scale: Double
    var arrowHoleRadius: Double
    var arrowHoleDiameter: Double {
        scale * arrowHoleRadius * 2
    }

    var body: some View {
        ForEach(arrowHoles) { hole in
            if let holePoint = hole.point {
                if isShadowEnabled {
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .position(holePoint
                            .scaleBy(scale)
                            .shiftBy(CGPointMake(arrowHoleDiameter, arrowHoleDiameter)))
                        .frame(width: arrowHoleDiameter * 2, height: arrowHoleDiameter * 2)
                }
                Circle()
                    .stroke(.white, lineWidth: 0.5)
                    .background(Circle().fill(.black))
                    .position(holePoint
                        .scaleBy(scale)
                        .shiftBy(CGPointMake(arrowHoleDiameter / 2, arrowHoleDiameter / 2)))
                    .frame(width: arrowHoleDiameter, height: arrowHoleDiameter)
            }
        }
    }
}
