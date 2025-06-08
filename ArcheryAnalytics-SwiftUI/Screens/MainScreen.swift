//
//  MainScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 12/22/23.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @EnvironmentObject private var navManager: NavManager
    @EnvironmentObject private var alertManager: AlertManager
    
//    @State private var dummyRefresh: Bool = false

    private func newData(jsonFileName: String) {
        storeModel.resetData(jsonFileName: jsonFileName)
        navManager.push(route: .home)
    }

    private func loadData(jsonFileName: String, fromBundle: Bool) {
        storeModel.loadData(jsonFileName: jsonFileName, fromBundle: fromBundle)
        navManager.push(route: .home)
    }
        
    var body: some View {
        List {
            Section("Device Data") {
                FileCell(title: "New \(StoreModel.mainFileName)", enabled: true) {
                    alertManager.showConfirmation(confirmationTitle: "Are you sure?",
                                                  confirmMessage: "Reset Data",
                                                  cancelMessage: "Cancel",
                                                  onConfirmTap: {
                        newData(jsonFileName: StoreModel.mainFileName)
                    })
                }
                FileCell(title: "Load \(StoreModel.mainFileName)", enabled: storeModel.doesFileExist(fileName: StoreModel.mainFileName)) {
                    loadData(jsonFileName: StoreModel.mainFileName, fromBundle: false)
                }
            }

            #if DEBUG
            Section("Bundle Data") {
                FileCell(title: "Load Sample", enabled: true) {
                    loadData(jsonFileName: "Sample", fromBundle: true)
                }
            }
            #endif
        }
        .navigationTitle("Menu")
        .onAppear {
//            dummyRefresh.toggle()
        }
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    @ObservedObject var navManager = NavManager()

    return NavigationStack(path: $navManager.path) {
        MainScreen()
            .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
    }
    .preferredColorScheme(.dark)
    .environmentObject(storeModel)
    .environmentObject(navManager)
}

struct FileCell: View {
    let title: String
    let enabled: Bool
    let onTap: () -> Void

    var body: some View {
        ListCell(onTap: onTap) {
            HStack {
                Text("\(title)")
                    .foregroundColor(enabled ? .primary : .gray)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(enabled ? .blue: .gray)
            }
            .padding(.horizontal, 12)
            .opacity(enabled ? 1 : 0.5)
        }
    }
}
