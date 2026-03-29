//
//  ShowUtils.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 30/03/26.
//


import Foundation

// MARK: - Helpers (Concurrency Safe)
enum ShowUtils {
    
    nonisolated static let parseStrategy = Date.ParseStrategy(
        format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)", timeZone: .autoupdatingCurrent
    )
    
    nonisolated static func parseDate(_ string: String?) -> Date? {
        guard let string else { return nil }
        return try? Date(string, strategy: parseStrategy)
    }
}
