//
//  TargetDetectorView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/27/23.
//

import SwiftUI

struct TargetDetectorView: View {
    @Binding var lastArrowHole: ArrowHole
    
    var scale: Double
    var targetWidth = 10.0
//    var padding: Double
    
    var frameSize: Double {
        scale * targetWidth
    }
    
    func tap(location: CGPoint) {
        // Tap relative to the center of the target
        let pt = CGPointMake(location.x - frameSize / 2, location.y - frameSize / 2)
        
        // Calculate the distance from center for the ring hit
        let ring = max(0, 10 - Int(sqrt(pt.x*pt.x + pt.y*pt.y) / scale * 2))
        
        // Calculate the scaled down pt. if targetWidth = 10, -5 to 5 in both x and y
        let downscaledPt = CGPointMake(pt.x / scale, pt.y / scale)

        print("TAP: \(location.formattedString) -> \(pt.formattedString) -> \(downscaledPt.formattedString), RING: \(ring)")
        // BUG: this is not setting correctly in preview
        self.lastArrowHole = ArrowHole(id: 0, point: downscaledPt, value: ring)
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
            }
        }
    }
}

#Preview {
    @State var lastArrowHole = ArrowHole(id: 0, point: CGPointZero, value: 0)
    
    return TargetDetectorView(lastArrowHole: $lastArrowHole, scale: 35.0)
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
        .padding()
    }
}

extension CGPoint {
    var formattedString: String {
        String(format: "(%.2f, %.2f)", self.x, self.y)
    }
}
