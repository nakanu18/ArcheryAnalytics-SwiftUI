//
//  TargetDetectorView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/27/23.
//

import SwiftUI

struct TargetDetectorView: View {
    var arrowHoles: [ArrowHole]

    var scale: Double
    var targetWidth = 40.0
    var padding = 15.0

    var arrowHoleRadius = 0.5

    var onTargetTap: ((ArrowHole) -> Void)?

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
        let ring = max(0, 10 - Int((downscaledDist - arrowHoleRadius) / 2))

        print("TAP: \(location.toString) -> \(downscaledPt.toString), DIST: \(String(format: "%.2f", downscaledDist)), RING: \(ring)")

        var arrowHole = ArrowHole()
        arrowHole.point = downscaledPt
        arrowHole.value = ring
        onTargetTap?(arrowHole)
    }

    var body: some View {
        HStack {
            ZStack {
                TargetView(scale: scale, targetWidth: targetWidth)
                    .frame(width: frameSize + padding * 2, height: frameSize + padding * 2)
                    .background(Color(red: 0.75, green: 0.75, blue: 0.75))
                    .onTapGesture(coordinateSpace: .local) { location in
                        addArrowHole(location: location)
                    }
                ArrowPlotView(arrowHoles: arrowHoles, scale: scale, arrowHoleRadius: arrowHoleRadius)
            }
        }
    }
}

#Preview {
    // BUG: arrow holes not showing in preview
    @State var arrowHoles: [ArrowHole] = []

    return TargetDetectorView(arrowHoles: arrowHoles, scale: 9.0) { arrowHole in
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

    var scale: Double
    var arrowHoleRadius: Double
    var arrowHoleDiameter: Double {
        scale * arrowHoleRadius * 2
    }

    var body: some View {
        ForEach(arrowHoles) { hole in
            if let holePoint = hole.point {
                Circle()
                    .stroke(.white, lineWidth: 1)
                    .background(Circle().fill(.black))
                    .position(holePoint
                        .scaleBy(scale)
                        .shiftBy(CGPointMake(arrowHoleDiameter / 2, arrowHoleDiameter / 2)))
                    .frame(width: arrowHoleDiameter, height: arrowHoleDiameter)
            }
        }
    }
}
