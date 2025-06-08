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
            RoundsScreen()
                .tabItem {
                    Label("Rounds", systemImage: "target")
                }
                .tag(Tab.rounds)
            Text("Coming Soon - Fine Tuning")
                .tabItem {
                    Label("Fine Tuning", systemImage: "tuningfork")
                }
                .tag(Tab.fineTuning)
            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }

    }
}
