//
//  Models.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 7/3/24.
//

import Foundation

struct Round: Identifiable, Codable {
    
    var id = UUID()
    let name: String
    let date: Date
    var ends: [End]
    let tags: [Tag]

    init(date: Date, name: String, numberOfEnds: Int, numberOfArrowsPerEnd: Int, tags: [Tag]) {
        self.date = date
        self.name = name
        self.ends = Array.init(repeating: End(numberOfArrowsPerEnd: numberOfArrowsPerEnd), count: numberOfEnds)
        self.tags = tags
    }
    
    var totalScore: Int {
        ends.reduce(0) { partialResult, end in
            return partialResult + end.totalScore
        }
    }
    
    var isFinished: Bool {
        ends.firstIndex { !$0.isFinished } == nil
    }
    
    var unfinishedEndID: Int {
        ends.firstIndex { !$0.isFinished } ?? -1
    }

    static var mockEmptyRound: Round {
        let round = Round(date: Date(),
                          name: "Vegas 300",
                          numberOfEnds: 10,
                          numberOfArrowsPerEnd: 3,
                          tags: [])

        return round
    }
    
}

struct End: Identifiable, Codable {
    
    var id = UUID()
    var arrowHoles: [ArrowHole] = []
    var numberOfArrowsPerEnd: Int
    
    var totalScore: Int {
        arrowHoles.reduce(0) { partialResult, hole in
            if hole.value >= 0 {
                return partialResult + hole.value
            }
            return partialResult
        }
    }
    
    var arrowValues: [Int] {
        arrowHoles.map { $0.value }
    }
    
    var isFinished: Bool {
        arrowHoles.firstIndex { $0.value == -1 } == nil
    }
    
    mutating func updateFirstUnmarkedArrowHole(arrowHole: ArrowHole) {
        if arrowHoles.count < numberOfArrowsPerEnd {
            arrowHoles.append(arrowHole)
        }
    }
    
    mutating func clearLastMarkedArrowHole() {
        if arrowHoles.count > 0 {
            arrowHoles.removeLast()
        }
    }
        
}

struct ArrowHole: Identifiable, Codable {
    
    var id = UUID()
    var point: CGPoint? = nil
    var value: Int = -1
    
    var toString: String {
        "\(point?.toString ?? "Unknown"), \(value)"
    }
        
}

struct Bow: Identifiable, Codable {
    
    var id = UUID()
    let name: String
    let tags: [Tag]
    
}

struct Tag: Identifiable, Codable {
    
    var id = UUID()
    let name: String
    
}
