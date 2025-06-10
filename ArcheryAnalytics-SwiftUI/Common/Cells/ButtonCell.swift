//
//  ButtonCell.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/6/25.
//

import SwiftUI

struct ButtonCell: View {
    let title: String
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        ListCell(onTap: onTap ?? {}) {
            HStack {
                Spacer()
                Text(title)
                Spacer()
            }
            .foregroundStyle(.link)
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    List {
        Section("Section") {
            ButtonCell(title: "Title") {
            }
        }
    }
    .preferredColorScheme(.dark)
}
