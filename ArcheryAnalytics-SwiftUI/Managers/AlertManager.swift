//
//  AlertManager.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/5/25.
//

import SwiftUI

class AlertManager: ObservableObject {
    @Published private var toastMessage: String? = nil
    @Published private var toastSpinner = false
    
    func showToast(message: String, spinner: Bool = false) {
        self.toastMessage = message
        self.toastSpinner = spinner
    }
    
    var toastOverlay: some View {
        ToastView(message: Binding(get: { self.toastMessage },
                                   set: { self.toastMessage = $0 }),
                  showSpinner: self.toastSpinner)
    }
}
