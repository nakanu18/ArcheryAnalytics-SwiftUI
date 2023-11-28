//
//  RoundFaceEditorView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/27/23.
//

import SwiftUI

struct ContentView: View {
//    @State private var circleValues: [Int?] = Array(repeating: nil, count: 10)

    let bgColor: [Color] = [.white, .white, .black, .black, .blue,  .blue,  .red,   .red,  .yellow, .yellow, .yellow]
    let lineColor = Color(red: 0.3, green: 0.3, blue: 0.3)
    let numberOfRings = 10
    let totalWidth = 10.0
    let scale = 35.0
    
    var ringWidth: Double {
        totalWidth / Double(numberOfRings)
    }
    
    func ringWidth(id: Int) -> CGFloat {
        let width = totalWidth - ringWidth * Double(id)
        return CGFloat(scale * width)
    }
    
    func normalize(point: CGPoint) -> String {
        let width = scale * totalWidth
        
        // Incorrect
        return String(format: "(%.2f, %.2f)", point.x, point.y)
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<numberOfRings, id: \.self) { index in
                Circle()
                    .stroke(lineColor, lineWidth: 1)
                    .background(
                        Circle()
                            .fill(bgColor[index])
                    )
                    // 400x400, [0,0] at top left
                    .frame(width: ringWidth(id: index))
                    .onTapGesture(coordinateSpace: .scrollView) { location in
                        circleTapped(index, with: location)
                    }
            }
        }
        .background(.gray)
        .padding()
        .onTapGesture(coordinateSpace: .scrollView) { location in
            circleTapped(-1, with: location)
        }
    }

    func circleTapped(_ index: Int, with location: CGPoint) {
//        circleValues[index] = index + 1
        print("\(index + 1): at \(normalize(point: location))")
    }
}

#Preview {
    ContentView()
}

extension CGPoint {
    var formattedString: String {
        return String(format: "(%.2f, %.2f)", self.x, self.y)
    }
}
