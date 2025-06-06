//
//  AlertManager.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/5/25.
//

import SwiftUI

class AlertManager: ObservableObject {
    @Published private var toastMessage: String? = nil
    private var toastSpinner = false
    
    @Published var showConfirmation = false
    private var confirmationTitle = ""
    private var confirmMessage = ""
    private var cancelMessage = ""
    private var onConfirmTap: () -> Void = {}
    private var onCancelTap: () -> Void = {}
    
    //
    // MARK: - Toast
    //
    
    func showToast(message: String, spinner: Bool = false) {
        self.toastMessage = message
        self.toastSpinner = spinner
    }
    
    var toastOverlay: some View {
        ToastView(message: Binding(get: { self.toastMessage },
                                   set: { self.toastMessage = $0 }),
                  showSpinner: self.toastSpinner)
    }
        
    //
    //
    // MARK: - Confirmation
    //
    
    func showConfirmation(confirmationTitle: String,
                          confirmMessage: String = "Confirm",
                          cancelMessage: String = "Cancel",
                          onConfirmTap: @escaping () -> Void = {},
                          onCancelTap: @escaping () -> Void = {}) {
        self.showConfirmation = true
        self.confirmationTitle = confirmationTitle
        self.confirmMessage = confirmMessage
        self.cancelMessage = cancelMessage
        self.onConfirmTap = {
            onConfirmTap()
            self.showConfirmation = false
        }
        self.onCancelTap = {
            onCancelTap()
            self.showConfirmation = false
        }
    }
    
    var confirmationSheet: some View {
        Color.clear
            .sheet(isPresented: Binding(get: { self.showConfirmation },
                                        set: { self.showConfirmation = $0 })) {
                ConfirmationView(title: self.confirmationTitle,
                                 confirmMessage: self.confirmMessage,
                                 cancelMessage: self.cancelMessage,
                                 onConfirmTap: self.onConfirmTap,
                                 onCancelTap: self.onCancelTap)
            }
    }
}
