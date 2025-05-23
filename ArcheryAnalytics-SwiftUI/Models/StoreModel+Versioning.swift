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
        
        let v2Model = StoreModel(rounds: [], selectedRoundID: UUID())
        
        v2Model.version = 2
        v2Model.saveDate = saveDate
        v2Model.fileName = fileName
        v2Model.selectedRoundID = selectedRoundID
        v2Model.toastMessage = toastMessage
        v2Model.rounds = rounds.map { v1Round in
            var round = Round()
            
            round.id = v1Round.id
            round.name = v1Round.name
            round.date = v1Round.date
            round.tags = v1Round.tags
            round.targetGroups = v1Round.targetGroups.map { v1TargetGroup in
                var targetGroup = TargetGroup()

                targetGroup.id = v1TargetGroup.id
                targetGroup.targetSize = v1TargetGroup.targetSize
                targetGroup.arrowSize = v1TargetGroup.arrowSize
                targetGroup.distance = v1TargetGroup.distance
                targetGroup.numberOfEnds = v1TargetGroup.numberOfEnds
                targetGroup.numberOfArrowsPerEnd = v1TargetGroup.numberOfArrowsPerEnd
                targetGroup.arrowHoles = v1TargetGroup.arrowHoles.map { v1ArrowHole in
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
                return targetGroup
            }
            return round
        }
        return v2Model
    }
}

//
// Models - define empty init's for easier version migration
//

extension Round {
    fileprivate init() {}
}

extension TargetGroup {
    fileprivate init() {}
}
