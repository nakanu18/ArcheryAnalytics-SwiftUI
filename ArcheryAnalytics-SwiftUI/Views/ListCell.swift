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
        .buttonStyle(ListCellStyle(shouldDisableFeedback: onTap == nil))
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

struct ListCellStyle: ButtonStyle {
    let shouldDisableFeedback: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        if shouldDisableFeedback {
            // No feedback - just show the label as-is
            configuration.label
        } else {
            // Default feedback behavior
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}
