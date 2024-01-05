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
    
    private func loadJSON(jsonFileName: String) {
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedStoreModel = try decoder.decode(StoreModel.self, from: data)
                
                // Update the properties of the existing storeModel
                storeModel.rounds = decodedStoreModel.rounds
                storeModel.selectedRoundID = decodedStoreModel.selectedRoundID
                                
                print("Loading JSON: \(jsonFileName)")
            }
            catch {
                print("Error loading JSON file: \(error)")
            }
        } else {
            print("Can not load JSON: \(jsonFileName)")
        }
        isPreNavDone = true
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Data Files") {
                    FileCell(title: "New File")
                        .onTapGesture {
                            isPreNavDone = true
                        }
                    FileCell(title: "Sample.json")
                        .onTapGesture {
                            loadJSON(jsonFileName: "Sample")
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
}

#Preview {
    MenuScreen()
        .environmentObject(StoreModel.mockEmpty)
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
