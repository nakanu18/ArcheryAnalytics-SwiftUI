//
//  ListCell.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/4/25.
//

import SwiftUI

struct ListCell<Content: View>: View {
    let onTap: (() -> Void)?
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        Button(action: onTap ?? {}) {
            content()
                .contentShape(Rectangle())
        }
        .listRowInsets(EdgeInsets())
        .foregroundColor(.white)
    }
}

#Preview {
    ListCell(onTap: {
        print("tapped")
    }) {
        Text("hi")
    }
    .background(Color.blue)
}
