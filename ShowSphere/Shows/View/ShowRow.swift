//
//  ShowRow.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 29/03/26.
//


import SwiftUI

// MARK: - Row View
struct ShowRow: View {
    
    let show: Show
    
    var body: some View {
        HStack {
            if let url = show.imageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 100)
                .clipped()
                .cornerRadius(8)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.2))
                    
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }
                .frame(width: 80, height: 100)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(show.name)
                    .font(.headline)
                
                if let rating = show.rating {
                    Text("⭐️ \(rating, specifier: "%.1f")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
