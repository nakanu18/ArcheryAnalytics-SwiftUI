//
//  ToastView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/18/25.
//

import SwiftUI

struct ToastView: View {
    @Binding var message: String?
    var showSpinner: Bool = false
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            if let message = message {
                VStack {
                    Spacer()
                    HStack() {
                        if showSpinner {
                            ProgressView()
                                .tint(.black)
                                .scaleEffect(1.5)
                                .padding(.leading, 15)
                        }
                        Text(message)
                            .padding()
                            .foregroundColor(.black)
                    }
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .opacity(isVisible ? 1 : 0)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isVisible)
                    .padding(.bottom, 50)
                }
                .onAppear {
                    withAnimation {
                        isVisible = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isVisible = false
                        }
                        // Remove message after animation completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.message = nil
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isVisible)
    }
}


#Preview {
    @Previewable @State var message: String? = "Hello, World!"
    
    return ToastView(message: $message, showSpinner: true)
}
