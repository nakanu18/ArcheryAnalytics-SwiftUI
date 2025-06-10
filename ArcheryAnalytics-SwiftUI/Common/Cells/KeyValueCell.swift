//
//  KeyValueCell.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/6/25.
//

import SwiftUI

struct KeyValueCell: View {
    let key: String
    let value: String
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        ListCell(onTap: onTap ?? {}) {
            HStack {
                Text(key)
                Spacer()
                Text(value)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    List {
        Section("Section") {
            KeyValueCell(key: "Key", value: "Value")
        }
    }
    .preferredColorScheme(.dark)
}
