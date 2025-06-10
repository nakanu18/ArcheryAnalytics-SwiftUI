//
//  EndCell.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/9/25.
//

import SwiftUI

struct EndCell: View {
    let stage: Stage
    let endIndex: Int
    let isSelected: Bool
    let onRowTap: (() -> Void)?
    let arrowValueSize = 28.0

    var arrowIDs: (start: Int, end: Int) {
        stage.arrowIDs(endID: endIndex)
    }

    var body: some View {
        ListCell(onTap: onRowTap) {
            HStack {
                Text("\(endIndex + 1)")
                    .frame(width: 34, height: 34)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .padding(.trailing, 8)

                ForEach(stage.arrowHoles[arrowIDs.start ..< arrowIDs.end]) { arrowHole in
                    if arrowHole.value >= 0 {
                        let isX = !stage.xPlusOne && arrowHole.value > stage.targetFaceType.numberOfRings
                        ZStack {
                            Text(isX ? "X" : "\(arrowHole.value)")
                                .frame(width: arrowValueSize, height: arrowValueSize)
                                .background(stage.targetFaceType.ringColors(value: arrowHole.value))
                                .foregroundColor(stage.targetFaceType.valueTextColor(value: arrowHole.value))
                                .cornerRadius(20)
                            Circle()
                                .stroke(.black, lineWidth: 2)
                                .frame(width: arrowValueSize, height: arrowValueSize)
                        }
                    }
                }

                Spacer()
                Text("\(stage.score(endID: endIndex))")
                    .foregroundColor(isSelected ? .black : .white)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(isSelected ? .green : Color.clear)
    //        .overlay(
    //            RoundedRectangle(cornerRadius: 8)
    //                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
    //        )
        }
    }
}
