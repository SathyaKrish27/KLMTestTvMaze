//
//  ShowFormatter.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 30/03/26.
//

import Foundation

enum ShowFormatter {
    static func summary(_ raw: String?) -> String? {
        guard let raw else { return nil }
        
        let stripped = raw.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        
        return stripped.isEmpty ? nil : stripped
    }
}
