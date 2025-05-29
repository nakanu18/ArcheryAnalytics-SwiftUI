//
//  ConfirmationView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/28/25.
//

import SwiftUI

struct ConfirmationView: View {
    var confirmMessage: String
    var cancelMessage: String
    var onConfirmTap: () -> Void
    var onCancelTap: () -> Void

    var body: some View {
        VStack {
            Button(confirmMessage, action: onConfirmTap)
            Button(cancelMessage, action: onCancelTap)
        }
        .presentationDetents([.fraction(0.3), .medium, .large])
        .presentationDragIndicator(.visible)
    }
}

extension View {
    func confirmationSheet(isPresented: Binding<Bool>, confirmMessage: String, cancelMessage: String, onConfirmTap: @escaping () -> Void, onCancelTap: @escaping () -> Void) -> some View {
        self.sheet(isPresented: isPresented) {
            ConfirmationView(confirmMessage: confirmMessage, cancelMessage: cancelMessage, onConfirmTap: onConfirmTap, onCancelTap: onCancelTap)
        }
    }
}

#Preview {
    return ConfirmationView(confirmMessage: "Continue",
                            cancelMessage: "Cancel",
                            onConfirmTap: {},
                            onCancelTap: {})
}
