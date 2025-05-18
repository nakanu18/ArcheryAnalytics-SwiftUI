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

    private func newData(jsonFileName: String) {
        storeModel.resetData(jsonFileName: jsonFileName)
        navManager.push(route: .rounds)
    }

    private func loadData(jsonFileName: String, fromBundle: Bool) {
        storeModel.loadData(jsonFileName: jsonFileName, fromBundle: fromBundle)
        navManager.push(route: .rounds)
    }
    
    private var doesDefaultFileExist: Bool {
        storeModel.doesFileExist(fileName: "Default")
    }

    var body: some View {
        List {
            Section("Data") {
                FileCell(title: "New Data", disabled: !doesDefaultFileExist) {
                    newData(jsonFileName: "Default")
                }
                FileCell(title: "Saved Data", disabled: doesDefaultFileExist) {
                    loadData(jsonFileName: "Default", fromBundle: false)
                }
            }

            Section("Debug") {
                FileCell(title: "Sample", disabled: false) {
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
    let title: String
    let disabled: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text("\(title)")
                .foregroundColor(disabled ? .gray : .primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(disabled ? .gray : .blue)
        }
        .contentShape(Rectangle()) // Make the entire HStack tappable
        .opacity(disabled ? 0.5 : 1)
        .onTapGesture {
            if !disabled {
                onTap()
            }
        }
    }
}
