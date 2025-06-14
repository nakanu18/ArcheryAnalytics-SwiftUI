//
//  TargetFaceType.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 6/13/25.
//

import Foundation
import SwiftUI

enum TargetFaceType: String, Codable {
    case gold
    case blue
    case fitaField
    
    var numberOfRings: Int {
        switch self {
        case .gold:
            return 10
        case .blue, .fitaField:
            return 5
        }
    }
    
    func ringToRingDistance(targetWidth: Double) -> Double {
        targetWidth / Double(numberOfRings) / 2
    }
    
    // Handles values of 0 to n, rings should start at index: 1
    func ringColors(value: Int) -> Color {
        var colors: [Color] = []

        // green ring is for misses
        switch self {
        case .gold:
            colors = [.dvGreen, .white, .white, .black, .black, .blue, .blue, .red, .red, .yellow, .yellow]
        case .blue:
            colors = [.dvGreen, .blue, .blue, .blue, .blue, .white]
        case .fitaField:
            colors = [.dvGreen, .dvTeal, .dvTeal, .dvTeal, .dvTeal, .yellow]
        }
        return colors[value.clamped(to: 0...colors.count - 1)]
    }
    
    var targetLineColor: Color {
        switch self {
        case .gold:
            return Color(red: 0.3, green: 0.3, blue: 0.3)
        case .blue, .fitaField:
            return Color(red: 0.1, green: 0.1, blue: 0.1)
        }
    }
    
    func valueTextColor(value: Int) -> Color {
        var colors: [Color] = []
        
        switch self {
        case .gold:
            colors = [.white, .black, .black, .white, .white, .white, .white, .white, .white, .black, .black]
        case .blue, .fitaField:
            colors = [.white, .white, .white, .white, .white, .black]
        }
        return colors[value.clamped(to: 0...colors.count - 1)]
    }
}
