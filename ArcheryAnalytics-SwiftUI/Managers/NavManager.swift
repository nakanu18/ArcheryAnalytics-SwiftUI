//
//  NavManager.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/15/24.
//

import SwiftUI

enum Route: Codable, Hashable {
    case home
    case roundEditor(round: Round)
    
    var description: String {
        switch self {
        case .home:
            return "Home"
        case .roundEditor(let round):
            return "RoundEditor: \(round.id)"
        }
    }
}

class NavManager: ObservableObject {
    @Published var path = NavigationPath()

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
        case .home:
            TabView {
                RoundsScreen()
                    .tabItem {
                        Label("Rounds", systemImage: "target")
                    }
                Text("Coming Soon - Fine Tuning")
                    .tabItem {
                        Label("Fine Tuning", systemImage: "tuningfork")
                    }
            }
        case .roundEditor(let round):
            RoundEditorScreen(round: round)
        }
    }
}
