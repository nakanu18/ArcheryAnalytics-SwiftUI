//
//  CGFloat+Extension.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 5/26/25.
//

import Foundation

extension CGFloat {
    
    func toString(decimals: Int = 3) -> String {
        String(format: "%.\(decimals)f", self)
    }
    
}
