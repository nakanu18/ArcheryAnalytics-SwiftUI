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
        Round(id: 0, date: Date(), arrowValues: [9,9,9, 9,9,9, 9,9,9, 8,8,8, 8,8,8,
                                                 9,9,9, 9,9,9, 9,9,9, 8,8,8, 8,8,8], numberOfEnds: 10, numberOfArrowsPerEnd: 3, tags: [])
    }

    static var mockHalfRound: Round {
        Round(id: 1, date: Date(), arrowValues: [9,9,9, 9,9,9, 9,9,9, 8,8,8, 8,8,8], numberOfEnds: 5, numberOfArrowsPerEnd: 3, tags: [])
    }
    
    func end(_ ID: Int) -> [Int] {
        var end: [Int] = []
        let startID = numberOfArrowsPerEnd * ID
        let endID = startID + numberOfArrowsPerEnd
        
        for i in startID..<endID {
            end.append(arrowValues[i])
        }
        print("\(ID), \(end)")
        return end
    }

}

struct Bow: Identifiable, Codable {
    
    let id: Int
    let name: String
    let tags: [Tag]
    
}

struct Tag: Identifiable, Codable {
    
    let id: Int
    let name: String
    
}
