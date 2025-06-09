//
//  MainTabsScreen.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/7/25.
//

import SwiftUI

struct MainTabsScreen: View {
    @EnvironmentObject var navManager: NavManager
    
    var body: some View {
        TabView(selection: $navManager.selectedTab) {
            NavigationStack(path: $navManager.roundsPath) {
                RoundsScreen()
                    .navigationDestination(for: Route.self) { route in
                        navManager.destination(route: route)
                    }
            }
            .tabItem {
                Label("Rounds", systemImage: "target")
            }
            .tag(Tab.rounds)

            NavigationStack(path: $navManager.fineTuningPath) {
                FineTuningScreen()
                    .navigationDestination(for: Route.self) { route in
                        navManager.destination(route: route)
                    }
            }
            .tabItem {
                Label("Fine Tuning", systemImage: "tuningfork")
            }
            .tag(Tab.fineTuning)

            NavigationStack(path: $navManager.settingsPath) {
                SettingsScreen()
                    .navigationDestination(for: Route.self) { route in
                        navManager.destination(route: route)
                    }
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(Tab.settings)
        }
    }
}
