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
        return rounds.first(where: { $0.id == selectedRoundID })!
    }
    
    // TODO: unsure why I don't get a default memberwise initializer
    init(rounds: [Round], selectedRoundID: UUID) {
        self.rounds = rounds
        self.selectedRoundID = selectedRoundID
    }
    
    static var mock: StoreModel {
        let mockRound = Round.mockFullRound
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
    
    static var mockFullRound: Round {
        var round = Round(date: Date(),
                          numberOfEnds: 10,
                          numberOfArrowsPerEnd: 3,
                          tags: [])
        round.ends[0].arrowValues = [10, 10, 10]
        round.ends[1].arrowValues = [10, 10, 9]
        round.ends[2].arrowValues = [10, 9, 9]
        round.ends[3].arrowValues = [9, 9, 9]
        round.ends[4].arrowValues = [8, 8, 6]
        round.ends[5].arrowValues = [8, 8, 5]
        round.ends[6].arrowValues = [8, 8, 4]
        round.ends[7].arrowValues = [8, 8, 3]
        round.ends[8].arrowValues = [8, 8, 2]
        round.ends[9].arrowValues = [8, 8, 1]

        return round
    }

}

struct End: Identifiable, Codable {
    
    var id = UUID()
    var arrowValues: [Int]
    
    init(numberOfArrowsPerEnd: Int) {
        self.arrowValues = Array.init(repeating: -1, count: numberOfArrowsPerEnd)
    }
    
    var totalScore: Int {
        arrowValues.reduce(0) { partialResult, val in
            if val >= 0 {
                return partialResult + val
            }
            return partialResult
        }
    }
    
    var isFinished: Bool {
        arrowValues.firstIndex { $0 == -1 } == nil
    }
    
}

struct Bow: Identifiable, Codable {
    
    var id = UUID()
    let name: String
    let tags: [Tag]
    
}

struct ArrowHole: Identifiable, Codable {
    
    var id = UUID()
    let point: CGPoint?
    let value: Int
    
    var toString: String {
        "\(point?.toString ?? "Unknown"), \(value)"
    }
    
}

struct Tag: Identifiable, Codable {
    
    var id = UUID()
    let name: String
    
}
