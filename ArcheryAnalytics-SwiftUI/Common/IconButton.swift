//
//  IconButton.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/13/25.
//

import SwiftUI


struct IconButton: View {
    var caption: String?
    var icon: String
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                if let caption = caption {
                    Text(caption)
                        .font(.caption)
                }
            }
        }
        .frame(width: 50, height: 44)
    }
}

#Preview {
    IconButton(caption: "Lock", icon: "lock") {
        print("onTap")
    }
    .background(.black)
}
