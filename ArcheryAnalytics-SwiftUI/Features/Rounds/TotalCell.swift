//
//  TotalCell.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/9/25.
//

import SwiftUI

struct TotalCell: View {
    let stage: Stage
    let isSelected: Bool
    let onRowTap: (() -> Void)?

    var body: some View {
        ListCell(onTap: onRowTap) {
            HStack {
                Text("Total")
                    .padding(.horizontal, 10)
                    .frame(height: 34)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                Spacer()
                Text("\(stage.totalScore)")
                    .foregroundColor(isSelected ? .black : .white)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(isSelected ? .green : Color.clear)
        }
    }
}
