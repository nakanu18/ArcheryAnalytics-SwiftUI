//
//  Comparable+Extension.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/30/25.
//

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(range.lowerBound, min(self, range.upperBound))
    }
}
