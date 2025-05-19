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

    @State private var dummyRefresh: Bool = false

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
            Section("Data") {
                FileCell(title: "New Data", enabled: !storeModel.doesFileExist(fileName: "Default")) {
                    newData(jsonFileName: "Default")
                }
                FileCell(title: "Saved Data", enabled: storeModel.doesFileExist(fileName: "Default")) {
                    loadData(jsonFileName: "Default", fromBundle: false)
                }
            }

            Section("Debug") {
                FileCell(title: "Sample", enabled: true) {
                    loadData(jsonFileName: "Sample", fromBundle: true)
                }
            }
        }
        .navigationTitle("Menu")
        .onAppear {
            dummyRefresh.toggle()
        }
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
