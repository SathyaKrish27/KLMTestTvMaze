//
//  StateView.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 29/03/26.
//


import SwiftUI

// MARK: - Reusable State View
struct StateView: View {
    
    let text: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.largeTitle)
            
            Text(text)
                .font(.headline)
        }
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
}
