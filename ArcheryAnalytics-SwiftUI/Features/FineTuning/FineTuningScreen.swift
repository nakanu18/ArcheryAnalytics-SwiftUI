//
//  FineTuningScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/8/25.
//

import SwiftUI

struct FineTuningScreen: View {
    var body: some View {
        List {
            Section("Info") {
                
            }
            
            Section("Tests") {
                
            }
        }
        .navigationTitle("Fine Tuning")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showNewRoundSheet = true
                } label: {
                    Image(systemName: "plus.circle")
                }
                .padding(.trailing, 16)
            }
        }
        
    }
}

#Preview {
    let storeModel = StoreModel.mock
    @ObservedObject var navManager = NavManager()
    @ObservedObject var alertManager = AlertManager()

    return NavigationStack(path: $navManager.fineTuningPath) {
        FineTuningScreen()
    }
    .preferredColorScheme(.dark)
    .environmentObject(storeModel)
    .environmentObject(navManager)
    .environmentObject(alertManager)
}
