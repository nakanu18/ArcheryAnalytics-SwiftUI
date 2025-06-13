//
//  StoreModel+Upgrade.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/22/25.
//

import Foundation

extension StoreModel {
    func migrateToLatestVersion() -> StoreModel {
        print("- Version check")
        if version > 1 {
            print("  V2 detected")
            return self
        }
        
        print("  V1 detected - converting to V2")
        
        let v2Model = StoreModel(rounds: [], tuningRounds: [])
        
        v2Model.version = 2
        v2Model.saveDate = saveDate
        v2Model.fileName = fileName
        v2Model.rounds = rounds.map { v1Round in
            var round = Round()
            
            round.id = v1Round.id
            round.name = v1Round.name
            round.date = v1Round.date
            round.tags = v1Round.tags
            round.stages = v1Round.stages.map { v1Stage in
                var stage = Stage()

                stage.id = v1Stage.id
                stage.targetSize = v1Stage.targetSize
                stage.arrowSize = v1Stage.arrowSize
                stage.distance = v1Stage.distance
                stage.numberOfEnds = v1Stage.numberOfEnds
                stage.numberOfArrowsPerEnd = v1Stage.numberOfArrowsPerEnd
                stage.arrowHoles = v1Stage.arrowHoles.map { v1ArrowHole in
                    var arrowHole = ArrowHole()
                    
                    arrowHole.id = v1ArrowHole.id
                    arrowHole.value = v1ArrowHole.value
                    if let point = v1ArrowHole.point {
                        arrowHole.point = CGPoint(
                            x: floor(point.x / 2 * 10000) / 10000,
                            y: floor(point.y / 2 * 10000) / 10000
                        )
                    }
                    return arrowHole
                }
                return stage
            }
            return round
        }
        return v2Model
    }
}

//
// Models - define empty init's for easier version migration
//

extension Stage {
    fileprivate init() {}
}
