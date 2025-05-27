//
//  GroupAnalyzer.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/25/25.
//

import Foundation

struct GroupAnalyzer {
    private(set) var arrowHoles: [ArrowHole]
    private(set) var sortedX: [ArrowHole] = []
    private(set) var sortedY: [ArrowHole] = []
    private(set) var groups: [CGSize] = []
    
    init(arrowHoles: [ArrowHole]) {
        self.arrowHoles = arrowHoles
        self.sortedX = sortByX()
        self.sortedY = sortByY()
        self.groups = calcGroup(throwOutliers: 2)
    }
        
    var numOfFinishedArrows: Int {
        return arrowHoles.filter { $0.value >= 0 }.count
    }
    
    var center: CGPoint {
        guard sortedX.count > 0, sortedY.count > 0 else {
            return CGPoint.zero
        }
        
        func median(of points: [ArrowHole], using keyPath: KeyPath<CGPoint, CGFloat>) -> CGFloat {
            let values = points.compactMap { $0.point?[keyPath: keyPath] }
            let sorted = values.sorted()
            let count = sorted.count

            if count % 2 == 0 {
                // Even number: take the average of the two middle values
                return (sorted[count / 2 - 1] + sorted[count / 2]) / 2
            } else {
                // Odd number: take the middle value
                return sorted[count / 2]
            }
        }

        let medianX = median(of: sortedX, using: \.x)
        let medianY = median(of: sortedY, using: \.y)

        return CGPoint(x: medianX, y: medianY)
    }

    private func sortByX() -> [ArrowHole] {
        let arrowHoles = arrowHoles.filter { $0.point != nil }
        guard arrowHoles.count > 1 else {
            return arrowHoles
        }

        return arrowHoles.sorted { $0.point!.x < $1.point!.x }
    }

    private func sortByY() -> [ArrowHole] {
        let arrowHoles = arrowHoles.filter { $0.point != nil }
        guard arrowHoles.count > 1 else {
            return arrowHoles
        }
        
        return arrowHoles.sorted { $0.point!.y < $1.point!.y }
    }
    
    private func calcGroup(throwOutliers: Int) -> [CGSize] {
        let arrowHoles = arrowHoles.filter { $0.point != nil }
        guard arrowHoles.count > 1 else {
            return []
        }

        var xSorted = sortByX()
        var ySorted = sortByY()
        var groups: [CGSize] = []
        var width  = xSorted[xSorted.count - 1].point!.x - xSorted[0].point!.x
        var height = ySorted[ySorted.count - 1].point!.y - ySorted[0].point!.y
        
        groups.append(CGSize(width: width, height: height))
        
        var outliers = throwOutliers
        while outliers > 0 {
            if xSorted.count > 2 {
                if xSorted[1].point!.x - xSorted[0].point!.x > xSorted[xSorted.count - 1].point!.x - xSorted[xSorted.count - 2].point!.x {
                    xSorted.removeFirst()
                } else {
                    xSorted.removeLast()
                }

                if ySorted[1].point!.x - ySorted[0].point!.y > ySorted[ySorted.count - 1].point!.y - ySorted[ySorted.count - 2].point!.y {
                    ySorted.removeFirst()
                } else {
                    ySorted.removeLast()
                }

                width  = xSorted[xSorted.count - 1].point!.x - xSorted[0].point!.x
                height = ySorted[ySorted.count - 1].point!.y - ySorted[0].point!.y
                groups.append(CGSize(width: width, height: height))
            }
            
            outliers -= 1
        }
        
        return groups
    }

}
