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
            PrimaryButton(title: confirmMessage, onTap: onConfirmTap)
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
