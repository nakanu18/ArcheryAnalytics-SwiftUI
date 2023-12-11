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
    
    static var mockFullRound: Round {
        var round = Round(date: Date(),
                          numberOfEnds: 10,
                          numberOfArrowsPerEnd: 3,
                          tags: [])
        round.ends[0].arrowHoles[0].value = 10
        round.ends[0].arrowHoles[1].value = 10
        round.ends[0].arrowHoles[2].value = 10

        round.ends[1].arrowHoles[0].value = 9
        round.ends[1].arrowHoles[1].value = 9
        round.ends[1].arrowHoles[2].value = 9

        round.ends[2].arrowHoles[0].value = 8
        round.ends[2].arrowHoles[1].value = 8
        round.ends[2].arrowHoles[2].value = 8

        round.ends[3].arrowHoles[0].value = 7
        round.ends[3].arrowHoles[1].value = 7
        round.ends[3].arrowHoles[2].value = 7

        round.ends[4].arrowHoles[0].value = 6
        round.ends[4].arrowHoles[1].value = 6
        round.ends[4].arrowHoles[2].value = 6

        round.ends[5].arrowHoles[0].value = 10
        round.ends[5].arrowHoles[1].value = 10
        round.ends[5].arrowHoles[2].value = 10

        round.ends[6].arrowHoles[0].value = 9
        round.ends[6].arrowHoles[1].value = 9
        round.ends[6].arrowHoles[2].value = 9

        round.ends[7].arrowHoles[0].value = 8
        round.ends[7].arrowHoles[1].value = 8
        round.ends[7].arrowHoles[2].value = 8

        round.ends[8].arrowHoles[0].value = 7
        round.ends[8].arrowHoles[1].value = 7
        round.ends[8].arrowHoles[2].value = 7

        round.ends[9].arrowHoles[0].value = 6
        round.ends[9].arrowHoles[1].value = 6
        round.ends[9].arrowHoles[2].value = 6

        return round
    }

    static var mockEmptyRound: Round {
        var round = Round(date: Date(),
                          numberOfEnds: 10,
                          numberOfArrowsPerEnd: 3,
                          tags: [])

        return round
    }

}

struct End: Identifiable, Codable {
    
    var id = UUID()
    var arrowHoles: [ArrowHole]
    
    init(numberOfArrowsPerEnd: Int) {
        self.arrowHoles = Array.init(repeating: ArrowHole(), count: numberOfArrowsPerEnd)
    }
    
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
