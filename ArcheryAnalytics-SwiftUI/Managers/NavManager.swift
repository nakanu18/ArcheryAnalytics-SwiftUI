//
//  NavManager.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/15/24.
//

import SwiftUI

enum Route: Codable, Hashable {
    case roundEditor(round: Round)
    
    var description: String {
        switch self {
        case .roundEditor(let round):
            return "RoundEditor: \(round.id)"
        }
    }
}

enum Tab: Hashable {
    case rounds
    case tuning
    case settings
}

class NavManager: ObservableObject {
    @Published var roundsPath = NavigationPath()
    @Published var tuningPath = NavigationPath()
    @Published var settingsPath = NavigationPath()
    @Published var selectedTab: Tab = .rounds

    var currentPath: NavigationPath {
        switch selectedTab {
        case .rounds:
            return roundsPath
        case .tuning:
            return tuningPath
        case .settings:
            return settingsPath
        }
    }
    
    func push(route: Route) {
        print("- NavManager: navigating to \(route.description)")
        switch selectedTab {
        case .rounds:
            roundsPath.append(route)
        case .tuning:
            tuningPath.append(route)
        case .settings:
            settingsPath.append(route)
        }
    }

    func pop() {
        print("- NavManager: popping current route")
        switch selectedTab {
        case .rounds:
            if !roundsPath.isEmpty {
                roundsPath.removeLast()
            }
        case .tuning:
            if !tuningPath.isEmpty {
                tuningPath.removeLast()
            }
        case .settings:
            if !settingsPath.isEmpty {
                settingsPath.removeLast()
            }
        }
    }

    func popToRoot() {
        print("- NavManager: popping to root")
        switch selectedTab {
        case .rounds:
            roundsPath = NavigationPath()
        case .tuning:
            tuningPath = NavigationPath()
        case .settings:
            settingsPath = NavigationPath()
        }
    }
    
    @ViewBuilder
    func destination(route: Route) -> some View {
        switch route {
        case .roundEditor(let round):
            RoundEditorScreen(round: round)
        }
    }
}
