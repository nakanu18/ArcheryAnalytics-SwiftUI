//
//  StoreModel.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 11/26/23.
//

import Foundation

class StoreModel: ObservableObject {
    
    @Published var rounds: [Round] = []
    
    init(rounds: [Round]) {
        self.rounds = rounds
    }
    
    static var mock: StoreModel {
        StoreModel(rounds: [Round.mockFullRound, Round.mockHalfRound])
    }
    
    func createNewRound() -> Int {
        let newRound = Round(id: rounds.count, date: Date(), arrowValues: [], numberOfEnds: 10, numberOfArrowsPerEnd: 3, tags: [])
    
        print("StoreModel: creating new round \(newRound.id)")
        self.rounds.append(newRound)
        return newRound.id
    }
    
}

struct Round: Identifiable, Codable {
    
    let id: Int
    let date: Date
    let arrowValues: [Int]
    let numberOfEnds: Int
    let numberOfArrowsPerEnd: Int
    let tags: [Tag]
    
    var totalScore: Int {
        arrowValues.reduce(0, +)
    }
    
    static var mockFullRound: Round {
        Round(id: 0, date: Date(), arrowValues: [9,9,1, 9,8,8, 7,7,7, 6,5,4, 3,2,0,
                                                 9,9,9, 9,9,9, 9,9,9, 8,8,8, 8,8,8], numberOfEnds: 10, numberOfArrowsPerEnd: 3, tags: [])
    }

    static var mockHalfRound: Round {
        Round(id: 1, date: Date(), arrowValues: [9,9,9, 9,9,9, 9,9,9, 8,8,8, 8,8,8], numberOfEnds: 5, numberOfArrowsPerEnd: 3, tags: [])
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
