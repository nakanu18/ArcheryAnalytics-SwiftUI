//
//  PrimaryButton.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/7/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var color: Color = .blue
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(title, action: onTap)
            .padding(.vertical, 8)
            .padding(.horizontal, 48)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(20)
            .font(.title3)
            .padding(.bottom)
    }
}

#Preview {
    PrimaryButton(title: "Title", color: .red) {
        print(123)
    }
}
