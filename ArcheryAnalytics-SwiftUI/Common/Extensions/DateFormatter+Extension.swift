//
//  DateFormatter+Extension.swift
//  ArcheryAnalytics-SwiftUI
//
//  Created by Alex de Vera on 12/27/23.
//

import Foundation

extension DateFormatter {
    static var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
