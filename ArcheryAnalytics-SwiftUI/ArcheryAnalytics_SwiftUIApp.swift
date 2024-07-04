//
//  ArcheryAnalytics_SwiftUIApp.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

@main
struct ArcheryAnalytics_SwiftUIApp: App {
    
    @StateObject private var storeModel = StoreModel.mockEmpty
        
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MenuScreen()
                    .environmentObject(storeModel)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                        print("didEnterBackgroundNotification")
                        storeModel.saveData()
                    }
                    .navigationBarTitleDisplayMode(.inline) // TODO: temp fix for big space on RoundEditorScreen
            }
        }
    }
    
}
