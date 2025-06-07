//
//  ArcheryAnalytics_SwiftUIApp.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

@main
struct ArcheryAnalytics_SwiftUIApp: App {
    @ObservedObject private var storeModel = StoreModel.mockEmpty
    @ObservedObject private var navManager = NavManager()
    @ObservedObject private var alertManager = AlertManager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $navManager.path) {
                    MenuScreen()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .rounds:
                                RoundsScreen()
                            case .roundEditor(let round):
                                RoundEditorScreen(round: round)
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                            print("- App: didEnterBackgroundNotification")
                            storeModel.saveData()
                        }
                }
                alertManager.confirmationSheet
                alertManager.toastOverlay
            }
            .preferredColorScheme(.dark)
            .environmentObject(storeModel)
            .environmentObject(navManager)
            .environmentObject(alertManager)
        }
    }
}
