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
    var targetGroups: [TargetGroup]
    let tags: [Tag]
    
    var currentTargetGroupID = 0

    init(date: Date, name: String, numberOfEnds: Int, numberOfArrowsPerEnd: Int, tags: [Tag]) {
        self.date = date
        self.name = name
        self.targetGroups = [(TargetGroup(targetSize: 40,
                                          arrowSize: 0.54,
                                          distance: 50,
                                          numberOfEnds: numberOfEnds,
                                          numberOfArrowsPerEnd: numberOfArrowsPerEnd))]
        self.tags = tags
    }
    
    var currentTargetGroup: TargetGroup {
        return targetGroups[currentTargetGroupID]
    }

    var isFinished: Bool {
        return targetGroups.filter(\.isFinished).count == targetGroups.count
    }
    
    var totalScore: Int {
        return targetGroups.reduce(0) { result, targetGroup in
            result + targetGroup.totalScore
        }
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

// 0.540cm -> 0.214" - VAP
// 0.675cm -> 0.266" - 17/64
// 0.912cm -> 0.359" - 23/64
struct TargetGroup: Identifiable, Codable {
    var id = UUID()
    var targetSize: Float // cm
    var arrowSize: Float // cm
    var distance: Int // m
    
    let numberOfEnds: Int
    let numberOfArrowsPerEnd: Int
    var arrowHoles: [ArrowHole] = []

    init(targetSize: Float, arrowSize: Float, distance: Int, numberOfEnds: Int, numberOfArrowsPerEnd: Int) {
        self.targetSize = targetSize
        self.arrowSize = arrowSize
        self.distance = distance
        self.numberOfEnds = numberOfEnds
        self.numberOfArrowsPerEnd = numberOfArrowsPerEnd
        // Build ArrowHoles with unique ids
        self.arrowHoles = (0 ..< numberOfEnds * numberOfArrowsPerEnd).map { _ in ArrowHole() }
    }

    func arrowIDs(endID: Int) -> (start: Int, end: Int) {
        guard endID >= 0, endID < numberOfEnds else {
            return (0, numberOfArrowsPerEnd)
        }

        let start = endID * numberOfArrowsPerEnd
        let end = start + numberOfArrowsPerEnd

        return (start, end)
    }
    
    var isFinished: Bool {
        return arrowHoles.allSatisfy { $0.value >= 0 }
    }
    
    var firstUnfinishedEndID: Int {
        for endID in 0 ..< numberOfEnds {
            let IDs = arrowIDs(endID: endID)

            if arrowHoles[IDs.start ..< IDs.end].contains(where: { $0.value == -1 }) {
                return endID
            }
        }
        return -1 // Return -1 if all ends are finished
    }

    func arrowHoles(endID: Int) -> [ArrowHole] {
        let IDs = arrowIDs(endID: endID)

        guard IDs.start >= 0, IDs.end <= arrowHoles.count else {
            return []
        }

        return Array(arrowHoles[IDs.start ..< IDs.end])
    }
    
    func arrowValues(endID: Int) -> [Int] {
        let IDs = arrowIDs(endID: endID)

        guard IDs.start >= 0, IDs.end <= arrowHoles.count else {
            return []
        }
        return arrowHoles[IDs.start ..< IDs.end].map { $0.value }
    }

    var allArrowValues: [Int] {
        return arrowHoles.map { $0.value }
    }

    func score(endID: Int) -> Int {
        return arrowValues(endID: endID).filter { $0 >= 0 }.reduce(0, +)
    }

    var totalScore: Int {
        return allArrowValues.filter { $0 >= 0 }.reduce(0, +)
    }

    mutating func updateFirstUnmarkedArrowHole(endID: Int, arrowHole: ArrowHole) {
        let IDs = arrowIDs(endID: endID)

        guard IDs.start >= 0, IDs.end <= arrowHoles.count else {
            return
        }

        if let index = arrowHoles[IDs.start ..< IDs.end].firstIndex(where: { $0.value == -1 }) {
            arrowHoles[index] = arrowHole
        }
    }

    mutating func clearLastMarkedArrowHole(endID: Int) {
        let IDs = arrowIDs(endID: endID)

        guard IDs.start >= 0, IDs.end <= arrowHoles.count else {
            return
        }

        if let index = arrowHoles[IDs.start ..< IDs.end].lastIndex(where: { $0.value != -1 }) {
            arrowHoles[index].clear()
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

    mutating func clear() {
        point = nil
        value = -1
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
