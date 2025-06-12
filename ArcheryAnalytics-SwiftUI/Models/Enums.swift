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
    case fineTuning(distance: Int)
    
    var name: String {
        switch self {
        case .vegasRound:
            return "Vegas"
        case .outdoorRound(distance: let distance):
            return "Outdoors \(distance)m"
        case .fieldRoundFlat:
            return "Field (Flat)"
        case .fineTuning(distance: let distance):
            return "Fine Tuning \(distance)m"
        }
    }
    
    var stages: [Stage] {
        var stages: [Stage] = []
        
        switch self {
        case .vegasRound:
            stages.append(Stage(targetFaceType: .gold, targetSize: 40, arrowSize: 0.5, distance: 18, numberOfEnds: 10, numberOfArrowsPerEnd: 3))
        case .outdoorRound(let distance):
            stages.append(Stage(targetFaceType: .gold, targetSize: 122, arrowSize: 0.5, distance: distance, numberOfEnds: 6, numberOfArrowsPerEnd: 6))
        case .fieldRoundFlat:
            stages.append(Stage(targetFaceType: .fitaField, targetSize: 60, arrowSize: 0.5, distance: 25, numberOfEnds: 1, numberOfArrowsPerEnd: 4, xPlusOne: true))
            stages.append(Stage(targetFaceType: .fitaField, targetSize: 60, arrowSize: 0.5, distance: 30, numberOfEnds: 1, numberOfArrowsPerEnd: 4, xPlusOne: true))
            stages.append(Stage(targetFaceType: .fitaField, targetSize: 60, arrowSize: 0.5, distance: 35, numberOfEnds: 1, numberOfArrowsPerEnd: 4, xPlusOne: true))

            stages.append(Stage(targetFaceType: .fitaField, targetSize: 80, arrowSize: 0.5, distance: 40, numberOfEnds: 1, numberOfArrowsPerEnd: 4, xPlusOne: true))
            stages.append(Stage(targetFaceType: .fitaField, targetSize: 80, arrowSize: 0.5, distance: 45, numberOfEnds: 1, numberOfArrowsPerEnd: 4, xPlusOne: true))
            stages.append(Stage(targetFaceType: .fitaField, targetSize: 80, arrowSize: 0.5, distance: 50, numberOfEnds: 1, numberOfArrowsPerEnd: 4, xPlusOne: true))

            stages.append(Stage(targetFaceType: .fitaField, targetSize: 20, arrowSize: 0.5, distance:  5, numberOfEnds: 1, numberOfArrowsPerEnd: 3, xPlusOne: true))
            stages.append(Stage(targetFaceType: .fitaField, targetSize: 20, arrowSize: 0.5, distance: 10, numberOfEnds: 1, numberOfArrowsPerEnd: 3, xPlusOne: true))

            stages.append(Stage(targetFaceType: .fitaField, targetSize: 40, arrowSize: 0.5, distance: 15, numberOfEnds: 1, numberOfArrowsPerEnd: 3, xPlusOne: true))
            stages.append(Stage(targetFaceType: .fitaField, targetSize: 40, arrowSize: 0.5, distance: 20, numberOfEnds: 1, numberOfArrowsPerEnd: 3, xPlusOne: true))
        case .fineTuning(let distance):
            stages.append(Stage(targetFaceType: .gold, targetSize: 122, arrowSize: 0.5, distance: distance, numberOfEnds: 2, numberOfArrowsPerEnd: 6))
            stages.append(Stage(targetFaceType: .gold, targetSize: 122, arrowSize: 0.5, distance: distance, numberOfEnds: 2, numberOfArrowsPerEnd: 6))
        }
        return stages
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
