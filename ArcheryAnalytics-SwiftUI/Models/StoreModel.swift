//
//  StoreModel.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import Foundation

class StoreModel: ObservableObject {
    
    @Published var rounds: [Round] = []
    @Published var selectedRoundID: Int = -1
    
    var selectedRound: Round {
        print("Selected Round ID: \(selectedRoundID)")
        return rounds.first(where: { $0.id == selectedRoundID })!
    }
    
    // TODO: unsure why I don't get a default memberwise initializer
    init(rounds: [Round], selectedRoundID: Int) {
        self.rounds = rounds
        self.selectedRoundID = selectedRoundID
    }
    
    static var mock: StoreModel {
        StoreModel(rounds: [Round.mockFullRound], selectedRoundID: 0)
    }
    
    func createNewRound() {
        let newRound = Round(id: rounds.count, date: Date(), numberOfEnds: 10, numberOfArrowsPerEnd: 3, tags: [])
    
        self.rounds.insert(newRound, at: 0)
        self.selectedRoundID = newRound.id
    }
    
}

struct Round: Identifiable, Codable {
    
    let id: Int
    let date: Date
    let numberOfEnds: Int
    let numberOfArrowsPerEnd: Int
    let arrowValues: [Int]
    let tags: [Tag]

    init(id: Int, date: Date, numberOfEnds: Int, numberOfArrowsPerEnd: Int, arrowValues: [Int], tags: [Tag]) {
        self.id = id
        self.date = date
        self.numberOfEnds = numberOfEnds
        self.numberOfArrowsPerEnd = numberOfArrowsPerEnd
        self.arrowValues = arrowValues
        self.tags = tags
    }

    init(id: Int, date: Date, numberOfEnds: Int, numberOfArrowsPerEnd: Int, tags: [Tag]) {
        self.id = id
        self.date = date
        self.numberOfEnds = numberOfEnds
        self.numberOfArrowsPerEnd = numberOfArrowsPerEnd
        self.arrowValues = Array(repeating: -1, count: numberOfEnds * numberOfArrowsPerEnd)
        self.tags = tags
    }
    
    var totalScore: Int {
        arrowValues.reduce(0, +)
    }
    
    static var mockFullRound: Round {
        Round(id: 0, 
              date: Date(),
              numberOfEnds: 10,
              numberOfArrowsPerEnd: 3,
              arrowValues: [9,9,1, 9,8,8, 7,7,7, 6,5,4, 3,2,0,
                            9,9,9, 9,9,9, 9,9,9, 8,8,8, 8,8,8],
              tags: [])
    }
    
    func end(_ ID: Int) -> End {
        var end: [Int] = []
        let startID = numberOfArrowsPerEnd * ID
        let endID = startID + numberOfArrowsPerEnd
        
        for i in startID..<endID {
            end.append(arrowValues[i])
        }
        return End(id: ID, arrowValues: end)
    }

}

struct End: Identifiable {
    
    let id: Int
    let arrowValues: [Int]
    
    var totalScore: Int {
        return arrowValues.reduce(0, +)
    }
    
}

struct Bow: Identifiable, Codable {
    
    let id: Int
    let name: String
    let tags: [Tag]
    
}

struct ArrowHole: Identifiable, Codable {
    
    let id: Int
    let point: CGPoint?
    let value: Int
    
    var toString: String {
        "\(point?.toString ?? "Unknown"), \(value)"
    }
    
}

struct Tag: Identifiable, Codable {
    
    let id: Int
    let name: String
    
}
