//
//  Models.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 7/3/24.
//

import Foundation

struct Round: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name = ""
    var date = Date()
    var stages: [Stage] = []
    var tags: [Tag] = []
    
    var totalNumberOfArrowsShot: Int {
        return stages.reduce(0) { result, stage in
            result + stage.totalNumberOfArrowsShot
        }
    }

    var totalNumberOfArrows: Int {
        return stages.reduce(0) { result, stage in
            result + stage.totalNumberOfArrows
        }
    }

    var isFinished: Bool {
        return stages.filter(\.isFinished).count == stages.count
    }
    
    var totalScore: Int {
        return stages.reduce(0) { result, stage in
            result + stage.totalScore
        }
    }

    var refCode: String {
        return stages.map { $0.refCode() }.joined(separator: " ")
    }
    
    static var mockEmptyRound: Round {
        var round = Round();
        round.name = "Mock Empty Round"
        round.stages.append(Stage(targetFaceType: .gold, targetSize: 40, arrowSize: 0.25, distance: 50, numberOfEnds: 6, numberOfArrowsPerEnd: 6))
        
        return round
    }

    static var mockFullRound: Round {
        var round = Round()
        round.name = "Mock Full Round"
        round.stages.append(Stage(targetFaceType: .gold, targetSize: 122, arrowSize: 0.25, distance: 50, numberOfEnds: 6, numberOfArrowsPerEnd: 6))

        round.stages[0].arrowHoles = []
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -0.30565990314738023, y: -0.40257642173487007), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 1.7668626850181524, y: -0.3205700230201703), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 1.1108121778368565, y: 2.422912737175229), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -3.1460595231984345, y: -0.1341922164156573), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -3.2429759280298702, y: 0.9766203026893581), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -2.3781822638007983, y: 2.9745914951985557), value: 9))
        
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.11182663846028618, y: -1.6997667474443985), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -2.6614768165049125, y: -0.33548037040506845), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.3503903765218076, y: 2.5571048398348353), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -1.0959023992322254, y: 2.9596811478136513), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -0.6635053964836067, y: 3.6082763106684173), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -3.645552349764747, y: -3.384623261259956), value: 8))
        
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.275839322133638, y: -0.872248894799548), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.5218581770095815, y: -1.8861446678049623), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -0.05218593145701157, y: 2.9895017288274), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 3.809564578413882, y: 0.5367682968823715), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 4.0779486699770375, y: -3.585911415249364), value: 8))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -4.018308190485874, y: 2.5123742527043538), value: 8))
        
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.6529286861908822, y: -0.20893731241976196), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 1.8456116201275437, y: -2.1503119393606482), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 3.24723186648397, y: 0.5484598307229791), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 1.3667972502542323, y: 2.6204204605794086), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 1.8369059043116667, y: 3.4039348840084673), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -4.953552564912182, y: 0.00870558297719981), value: 8))
        
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -0.15670301752449076, y: -0.13929145305405338), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.40916864334628955, y: -0.609400107111488), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 2.063254382685825, y: 1.5496174152263633), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.06964559368834797, y: 3.012177672293938), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.6181056900886878, y: 3.4213460499628607), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -3.2907608440794056, y: -1.9587860585726433), value: 9))
        
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 0.36274714284244663, y: -1.1750970392259477), value: 10))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: 1.2568426754923097, y: 2.8815417666288883), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -3.4895269096955257, y: -0.3525292209102954), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -0.2094739481597464, y: -2.8968694291164763), value: 9))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -3.014379117447286, y: 3.5201815330402786), value: 8))
        round.stages[0].arrowHoles.append(ArrowHole(point: CGPoint(x: -1.5736080782149695, y: -5.303263481456058), value: 8))
        return round
    }
    
    static var mockEmptyTuningRound: Round {
        var round = Round();
        round.name = "Mock Empty Tuning Round"
        round.stages.append(Stage(targetFaceType: .gold, targetSize: 122, arrowSize: 0.25, distance: 50, numberOfEnds: 2, numberOfArrowsPerEnd: 6))
        round.stages.append(Stage(targetFaceType: .gold, targetSize: 122, arrowSize: 0.25, distance: 50, numberOfEnds: 2, numberOfArrowsPerEnd: 6))

        return round
    }
}

// 0.540cm -> 0.214" - VAP
// 0.675cm -> 0.266" - 17/64
// 0.912cm -> 0.359" - 23/64
struct Stage: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var targetSize: Int = 40 // cm
    var arrowSize: Float = 0.54 // cm
    var distance: Int = 20 // m
    
    var targetFaceType: TargetFaceType = .gold
    var numberOfEnds: Int = 10
    var numberOfArrowsPerEnd: Int = 3
    var xPlusOne: Bool = false
    var arrowHoles: [ArrowHole] = []

    init(targetFaceType: TargetFaceType, targetSize: Int, arrowSize: Float, distance: Int, numberOfEnds: Int, numberOfArrowsPerEnd: Int, xPlusOne: Bool = false) {
        self.targetFaceType = targetFaceType
        self.targetSize = targetSize
        self.arrowSize = arrowSize
        self.distance = distance
        self.numberOfEnds = numberOfEnds
        self.numberOfArrowsPerEnd = numberOfArrowsPerEnd
        self.xPlusOne = xPlusOne
        // Build ArrowHoles with unique ids
        self.arrowHoles = (0 ..< numberOfEnds * numberOfArrowsPerEnd).map { _ in ArrowHole() }
    }
    
    func refCode() -> String {
        return "WA_\(targetSize)cm_\(distance)m_\(numberOfEnds)x\(numberOfArrowsPerEnd)"
    }

    func arrowIDs(endID: Int) -> (start: Int, end: Int) {
        guard endID >= 0, endID < numberOfEnds else {
            return (0, numberOfArrowsPerEnd)
        }

        let start = endID * numberOfArrowsPerEnd
        let end = start + numberOfArrowsPerEnd

        return (start, end)
    }
        
    var totalNumberOfArrowsShot: Int {
        return arrowHoles.filter { $0.value >= 0 }.count
    }

    var totalNumberOfArrows: Int {
        return numberOfEnds * numberOfArrowsPerEnd
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
    
    func score(endID: Int) -> Int {
        var numXs = 0
        var score = 0

        arrowHoles(endID: endID).forEach { arrowHole in
            if arrowHole.value >= 0 {
                score = score + arrowHole.value
                if arrowHole.value > targetFaceType.numberOfRings {
                    numXs = numXs + 1
                }
            }
        }
        return xPlusOne ? score : score - numXs
    }

    var totalScore: Int {
        var score = 0
        for endID in 0 ..< numberOfEnds {
            score = score + self.score(endID: endID)
        }
        return score
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

struct ArrowHole: Identifiable, Codable, Equatable, Hashable {
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

struct Bow: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    let name: String
    let tags: [Tag]
}

struct Tag: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    let name: String
}
