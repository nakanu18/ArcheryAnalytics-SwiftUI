//
//  ArcheryAnalytics_SwiftUIApp.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import SwiftUI

@main
struct ArcheryAnalytics_SwiftUIApp: App {
    private var storeModel = StoreModel.mockEmpty
    @ObservedObject private var navManager = NavManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navManager.path) {
                MenuScreen()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .rounds:
                            RoundsScreen()
                        case let .roundEditor(roundID):
                            RoundEditorScreen(roundID: roundID)
                        }
                    }
                    .onReceive(
                        NotificationCenter.default.publisher(
                            for: UIApplication.didEnterBackgroundNotification)
                    ) { _ in
                        print("didEnterBackgroundNotification")
                        storeModel.saveData()
                    }
            }.preferredColorScheme(.dark)
                .environmentObject(storeModel)
                .environmentObject(navManager)
        }
    }
}
