//
//  NavManager.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/15/24.
//

import SwiftUI

enum Route: Codable, Hashable {
    case rounds
    case roundEditor(roundID: UUID)
}

class NavManager: ObservableObject {
    @Published var path = NavigationPath()

    func push(route: Route) {
        print("*** Navigating to: [\(route)]")
        path.append(route)
    }

    func pop() {
        print("*** Popping current route")
        path.removeLast()
    }

    func popToRoot() {
        print("*** Popping to root")
        path.removeLast(path.count)
    }
}
