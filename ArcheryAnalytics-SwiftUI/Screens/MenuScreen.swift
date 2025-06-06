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
    
    @State private var showConfirmation = false

//    @State private var dummyRefresh: Bool = false

    private func newData(jsonFileName: String) {
        storeModel.resetData(jsonFileName: jsonFileName)
        navManager.push(route: .rounds)
    }

    private func loadData(jsonFileName: String, fromBundle: Bool) {
        storeModel.loadData(jsonFileName: jsonFileName, fromBundle: fromBundle)
        navManager.push(route: .rounds)
    }
        
    var body: some View {
        List {
            Section("Device Data") {
                FileCell(title: "New Default.json", enabled: true) {
                    showConfirmation = true
                }
                FileCell(title: "Load Default.json", enabled: storeModel.doesFileExist(fileName: "Default")) {
                    loadData(jsonFileName: "Default", fromBundle: false)
                }
            }

            Section("Bundle Data") {
                FileCell(title: "Load Sample.json", enabled: true) {
                    loadData(jsonFileName: "Sample", fromBundle: true)
                }
            }
        }
        .navigationTitle("Menu")
        .onAppear {
//            dummyRefresh.toggle()
        }
        .confirmationSheet(isPresented: $showConfirmation, title: "Are you sure?", confirmMessage: "Reset Data", cancelMessage: "Cancel",
            onConfirmTap: {
                newData(jsonFileName: "Default")
                showConfirmation = false
            },
            onCancelTap: {
                showConfirmation = false
            }
        )
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
    let title: String
    let enabled: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text("\(title)")
                .foregroundColor(enabled ? .primary : .gray)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(enabled ? .blue: .gray)
        }
        .contentShape(Rectangle()) // Make the entire HStack tappable
        .opacity(enabled ? 1 : 0.5)
        .onTapGesture {
            if enabled {
                onTap()
            }
        }
    }
}
