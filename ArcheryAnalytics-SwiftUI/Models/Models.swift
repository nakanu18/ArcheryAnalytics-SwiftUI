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
    let numberOfEnds: Int
    let numberOfArrowsPerEnd: Int
    var arrowHoles: [ArrowHole]
    let tags: [Tag]

    init(date: Date, name: String, numberOfEnds: Int, numberOfArrowsPerEnd: Int, tags: [Tag]) {
        self.date = date
        self.name = name
        self.numberOfEnds = numberOfEnds
        self.numberOfArrowsPerEnd = numberOfArrowsPerEnd
        arrowHoles = (0 ..< numberOfEnds * numberOfArrowsPerEnd).map { _ in ArrowHole() }
        self.tags = tags
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

    static var mockEmptyRound: Round {
        let round = Round(date: Date(),
                          name: "Vegas 300",
                          numberOfEnds: 10,
                          numberOfArrowsPerEnd: 3,
                          tags: [])

        return round
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
