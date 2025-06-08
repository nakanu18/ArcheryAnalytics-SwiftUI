//
//  NavManager.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/15/24.
//

import SwiftUI

enum Route: Codable, Hashable {
    case rounds
    case roundEditor(round: Round)
    
    var description: String {
        switch self {
        case .rounds:
            return "Rounds"
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
        case .rounds:
            RoundsScreen()
        case .roundEditor(let round):
            RoundEditorScreen(round: round)
        }
    }
}
