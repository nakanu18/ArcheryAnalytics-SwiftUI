//
//  MenuScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 12/22/23.
//

import SwiftUI

struct MenuScreen: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    @EnvironmentObject private var navManager: NavManager
    
    private func newData() {
        storeModel.resetData()
        navManager.push(route: .rounds)
    }
    
    private func loadData(jsonFileName: String, fromBundle: Bool) {
        storeModel.loadData(jsonFileName: jsonFileName, fromBundle: fromBundle)
        navManager.push(route: .rounds)
    }

    var body: some View {
            List {
                Section("Data Files") {
                    FileCell(title: "New File")
                        .onTapGesture {
                            newData()
                        }
                    FileCell(title: "Sample")
                        .onTapGesture {
                            loadData(jsonFileName: "Sample", fromBundle: true)
                        }
                }
            }.navigationTitle("Menu")
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.path) {
        MenuScreen()
            .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
    }.preferredColorScheme(.dark)
        .environmentObject(storeModel)
        .environmentObject(navManager)
}

struct FileCell: View {
    var title: String
    
    var body: some View {
        HStack {
            Text("\(title)")
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
        .contentShape(Rectangle()) // Make the entire HStack tappable
    }
}
