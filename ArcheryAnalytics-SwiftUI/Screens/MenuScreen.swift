//
//  MenuScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 12/22/23.
//

import SwiftUI

struct MenuScreen: View {
    
    @EnvironmentObject private var storeModel: StoreModel
    @State private var isPreNavDone = false
    
    private func newData() {
        storeModel.resetData()
        isPreNavDone = true
    }
    
    private func loadData(jsonFileName: String, fromBundle: Bool) {
        storeModel.loadData(jsonFileName: jsonFileName, fromBundle: fromBundle)
        isPreNavDone = true
    }

    var body: some View {
            List {
                Section("Data Files") {
                    FileCell(title: "New File")
                        .onTapGesture {
                            newData()
                        }
                    FileCell(title: "Default")
                        .onTapGesture {
                            loadData(jsonFileName: "Default", fromBundle: false)
                        }
                    FileCell(title: "Sample")
                        .onTapGesture {
                            loadData(jsonFileName: "Sample", fromBundle: true)
                        }
                }
            }
            .navigationTitle("Menu")
            .navigationDestination(isPresented: $isPreNavDone, destination: {
                RoundsScreen()
                    .environmentObject(storeModel)
            })
    }
}

#Preview {
    NavigationStack {
        MenuScreen()
            .environmentObject(StoreModel.mockEmpty)
            .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
    }
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
