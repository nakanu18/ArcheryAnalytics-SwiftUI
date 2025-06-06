//
//  ConfirmationView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/28/25.
//

import SwiftUI

struct ConfirmationView: View {
    var title: String
    var confirmMessage: String
    var cancelMessage: String
    var onConfirmTap: () -> Void
    var onCancelTap: () -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
            Button(confirmMessage, action: onConfirmTap)
                .padding(.vertical, 8)
                .padding(.horizontal, 48)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .font(.title3)
                .padding(.bottom)
            Button(cancelMessage, action: onCancelTap)
        }
        .presentationDetents([.fraction(0.3), .medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    return ConfirmationView(title: "Are you sure?",
                            confirmMessage: "Continue",
                            cancelMessage: "Cancel",
                            onConfirmTap: {},
                            onCancelTap: {})
}
