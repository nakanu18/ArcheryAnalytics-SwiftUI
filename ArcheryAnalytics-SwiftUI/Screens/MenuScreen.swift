//
//  MenuScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 12/22/23.
//

import SwiftUI

struct MenuScreen: View {
    
    @EnvironmentObject private var storeModel: StoreModel

    var body: some View {
        NavigationStack {
            List {
                Section("Save Files") {
                    NavigationLink("Use Empty File") {
                        RoundsScreen()
                            .environmentObject(storeModel)
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}

#Preview {
    MenuScreen()
        .environmentObject(StoreModel.mockEmpty)
}
