//
//  ToastView.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/18/25.
//

import SwiftUI

struct ToastView: View {
    @Binding var message: String?
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            if let message = message {
                VStack {
                    Spacer()
                    Text(message)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .foregroundColor(.white)
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
    
    return ToastView(message: $message)
}
