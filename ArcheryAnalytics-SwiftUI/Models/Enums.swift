//
//  Enums.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/29/25.
//

import Foundation
import SwiftUI

enum RoundType {
    case vegasRound
    case outdoorRound(distance: Int)
    case fieldRoundFlat
    
    var name: String {
        switch self {
            case .vegasRound:
                return "Vegas"
            case .outdoorRound(distance: let distance):
                return "Outdoors \(distance)m"
            case .fieldRoundFlat:
                return "Field (Flat)"
        }
    }
}

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
        targetWidth / Double(numberOfRings)
    }
    
    // Handles values of 0 to n, rings should start at index: 1
    func ringColors(value: Int) -> Color {
        var colors: [Color] = []

        // green ring is for misses
        switch self {
        case .gold:
            colors = [.darkGreen, .white, .white, .black, .black, .blue, .blue, .red, .red, .yellow, .yellow, .yellow]
        case .blue:
            colors = [.darkGreen, .blue, .blue, .blue, .blue, .white]
        case .fitaField:
            colors = [.darkGreen, .customTeal, .customTeal, .customTeal, .customTeal, .yellow]
        }
        return value >= 0 && value < colors.count ? colors[value] : .black
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
            colors = [.white, .white, .white, .white, .white, .black, .black]
        }
        return value >= 0 && value < colors.count ? colors[value] : .black
    }
}
