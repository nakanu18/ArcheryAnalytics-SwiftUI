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
        print("*** NavManager: navigating to: [\(route)]")
        path.append(route)
    }

    func pop() {
        print("*** NavManager: popping current route")
        path.removeLast()
    }

    func popToRoot() {
        print("*** NavManager: popping to root")
        path.removeLast(path.count)
    }
}
