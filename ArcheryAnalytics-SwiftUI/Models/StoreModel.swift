//
//  StoreModel.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import Foundation

class StoreModel: ObservableObject {
    
    @Published var rounds: [Round] = []
    @Published var selectedRoundID: UUID
    
    var selectedRound: Round {
        get {
            return rounds.first(where: { $0.id == selectedRoundID })!
        }
        set {
            // Implement the logic to update selectedRoundID when the selectedRound changes
            if let index = rounds.firstIndex(where: { $0.id == selectedRoundID }) {
                rounds[index] = newValue
                selectedRoundID = newValue.id
            }
        }
    }
    
    init(rounds: [Round], selectedRoundID: UUID) {
        self.rounds = rounds
        self.selectedRoundID = selectedRoundID
    }

    static var mockEmpty: StoreModel {
        let mockRound = Round.mockEmptyRound
        return StoreModel(rounds: [mockRound], selectedRoundID: mockRound.id)
    }

    func createNewRound() {
        let newRound = Round(date: Date(), numberOfEnds: 10, numberOfArrowsPerEnd: 3, tags: [])
    
        self.rounds.insert(newRound, at: 0)
        self.selectedRoundID = newRound.id
    }
    
}

struct Round: Identifiable, Codable {
    
    var id = UUID()
    let date: Date
    var ends: [End]
    let tags: [Tag]

    init(date: Date, numberOfEnds: Int, numberOfArrowsPerEnd: Int, tags: [Tag]) {
        self.date = date
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
