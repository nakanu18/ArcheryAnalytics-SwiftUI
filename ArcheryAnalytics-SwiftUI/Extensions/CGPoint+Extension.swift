//
//  CGPoint+Extension.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 12/1/23.
//

import Foundation
import SwiftUI

extension CGPoint {
    var toString: String {
        String(format: "%.2f, %.2f", x, y)
    }

    func scaleBy(_ scale: Double) -> CGPoint {
        return CGPointMake(x * scale, y * scale)
    }

    func shiftBy(_ pt: CGPoint) -> CGPoint {
        return CGPoint(x: x + pt.x, y: y + pt.y)
    }
}
