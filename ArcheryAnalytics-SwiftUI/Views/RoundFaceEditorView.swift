//
//  RoundFaceEditorView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/27/23.
//

import SwiftUI

struct RoundFaceEditorView: View {
    var scale: Double
    var targetWidth = 10.0
//    var padding: Double
    
    var frameSize: Double {
        scale * targetWidth
    }
    
    func tap(location: CGPoint) {
        let pt = CGPointMake(location.x - frameSize / 2, location.y - frameSize / 2)
        let ring =  max(0, 10 - Int(sqrt(pt.x*pt.x + pt.y*pt.y) / scale * 2))

        print("\(location.formattedString) -> \(pt.formattedString), \(ring)")
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
    RoundFaceEditorView(scale: 35.0)
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
                        print("\(index + 1): \(ringWidth(id: index))")
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
