//
//  TargetDetectorView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/27/23.
//

import SwiftUI

struct TargetDetectorView: View {
    @Binding var arrowHoles: [ArrowHole]
    
    var scale: Double
    var targetWidth = 20.0
//    var padding: Double
    
    var arrowHoleRadius = 0.25
    var arrowHoleDiameter: Double {
        scale * arrowHoleRadius * 2
    }
    
    var frameSize: Double {
        scale * targetWidth
    }
    
    func tap(location: CGPoint) {
        // Tap relative to the center of the target
        let pt = CGPointMake(location.x - frameSize / 2, location.y - frameSize / 2)
        
        // Calculate the distance from center for the ring hit
        let dist = sqrt(pt.x*pt.x + pt.y*pt.y)
        
        // Calculate the scaled down pt. if targetWidth = 10, -5 to 5 in both x and y
        let downscaledPt = CGPointMake(pt.x / scale, pt.y / scale)
        let downscaledDist = dist / scale

        // Calculate which ring was hit
        let ring = max(0, 10 - Int(downscaledDist - arrowHoleRadius))

        print("TAP: \(location.toString) -> \(downscaledPt.toString), DIST: \(String(format: "%.2f", downscaledDist)), RING: \(ring)")
        // BUG: this is not setting correctly in preview
        arrowHoles.append(ArrowHole(point: downscaledPt, value: ring))
    }
    
    var body: some View {
        HStack {
            ZStack {
                TargetView(scale: scale, targetWidth: targetWidth)
                    Color.gray
                    .frame(width: frameSize, height: frameSize)
                    .opacity(0.0)
                    .contentShape(Rectangle())
                    .onTapGesture(coordinateSpace: .local) { location in
                        tap(location: location)
                    }
                ArrowPlotView(arrowHoles: $arrowHoles, scale: scale, arrowHoleRadius: arrowHoleRadius)
            }
        }
    }
}

#Preview {
    @State var arrowHoles: [ArrowHole] = []
    
    return TargetDetectorView(arrowHoles: $arrowHoles, scale: 20.0)
}

struct TargetView: View {
    let bgColor: [Color] = [.white, .white, .black, .black, .blue,  .blue,  .red,   .red,  .yellow, .yellow, .yellow]
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
            ForEach(0..<numberOfRings, id: \.self) { index in
                Circle()
                    .stroke(lineColor, lineWidth: 1)
                    .background(Circle().fill(bgColor[index]))
                    .frame(width: ringWidth(id: index))
                    .onAppear {
//                        print("\(index + 1): \(ringWidth(id: index))")
                    }
            }
        }
        .background(.gray)
    }
}

struct ArrowPlotView: View {
    @Binding var arrowHoles: [ArrowHole]

    var scale: Double
    var arrowHoleRadius: Double
    var arrowHoleDiameter: Double {
        scale * arrowHoleRadius * 2
    }

    var body: some View {
        ForEach(arrowHoles) { hole in
            if let holePoint = hole.point {
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .background(Circle().fill(.gray))
                    .position(holePoint
                        .scaleBy(scale)
                        .shiftBy(CGPointMake(arrowHoleDiameter / 2, arrowHoleDiameter / 2)))
                    .frame(width: arrowHoleDiameter, height: arrowHoleDiameter)
            }
        }
    }
}
