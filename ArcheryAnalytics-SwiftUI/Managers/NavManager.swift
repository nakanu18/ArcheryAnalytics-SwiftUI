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
    case fineTuning
    case settings
}

class NavManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Tab = .rounds

    func push(route: Route) {
        print("- NavManager: navigating to \(route.description)")
        path.append(route)
    }

    func pop() {
        print("- NavManager: popping current route")
        path.removeLast()
    }

    func popToRoot() {
        print("- NavManager: popping to root")
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func destination(route: Route) -> some View {
        switch route {
        case .roundEditor(let round):
            RoundEditorScreen(round: round)
        }
    }
}
