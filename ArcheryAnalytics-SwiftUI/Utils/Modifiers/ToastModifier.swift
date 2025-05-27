//
//  ToastModifier.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/18/25.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var message: String?
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
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

extension View {
    func toast(message: Binding<String?>) -> some View {
        self.modifier(ToastModifier(message: message))
    }}

#Preview {
    struct PreviewWrapper: View {
        @State private var toastMessage: String? = "This is a test toast"

        var body: some View {
            VStack {
                Text("Hello, world!")
                    .padding()
            }
            .toast(message: $toastMessage)
        }
    }
    
    return PreviewWrapper()
}
