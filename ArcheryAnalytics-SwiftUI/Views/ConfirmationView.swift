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
    var onConfirmButtonTap: () -> Void
    var onCancelButtonTap: () -> Void

    var body: some View {
        VStack {
            Button(confirmMessage, action: onConfirmButtonTap)
            Button(cancelMessage, action: onCancelButtonTap)
        }
    }
}

#Preview {
    return ConfirmationView(confirmMessage: "Continue",
                            cancelMessage: "Cancel",
                            onConfirmButtonTap: {},
                            onCancelButtonTap: {})
}
