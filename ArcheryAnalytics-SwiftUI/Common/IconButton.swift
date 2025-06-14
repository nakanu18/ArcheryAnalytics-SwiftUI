//
//  IconButton.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/13/25.
//

import SwiftUI


struct IconButton: View {
    var caption: String
    var icon: String
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(caption)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    IconButton(caption: "Lock", icon: "lock") {
        print("onTap")
    }
}
