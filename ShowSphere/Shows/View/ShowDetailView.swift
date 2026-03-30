//
//  ShowDetailView.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 29/03/26.
//


import SwiftUI

struct ShowDetailView: View {
    
    let show: Show
    var isLoading: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                PosterView(url: self.show.imageURL)
                self.content
            }
            .padding()
        }
        .navigationTitle(self.show.name)
        .inlineTitleIfiOS()
        .redacted(reason: self.isLoading ? .placeholder : [])
        .animation(.easeInOut, value: self.isLoading)
    }
    
    // MARK: - Main Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView(
                title: self.show.name,
                rating: self.show.rating
            )
            
            MetaInfoView(
                genres: self.show.genres,
                premiered: self.show.premiered
            )
            
            if let summary = ShowFormatter.summary(show.summary) {
                DescriptionView(text: summary)
            }
        }
    }
}

// MARK: - Components

private struct PosterView: View {
    let url: URL?
    
    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .overlay(ProgressView())
                }
            } else {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .overlay(Image(systemName: "photo"))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct HeaderView: View {
    let title: String
    let rating: Double?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.title)
                .font(.title)
                .bold()
            
            if let rating {
                Label("\(rating, specifier: "%.1f")", systemImage: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
    }
}

private struct MetaInfoView: View {
    let genres: [String]
    let premiered: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !self.genres.isEmpty {
                Text(self.genres.joined(separator: " • "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if let premiered {
                Text("Premiered: \(premiered.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct DescriptionView: View {
    let text: String
    
    var body: some View {
        Text(self.text)
            .font(.body)
            .lineSpacing(4)
    }
}

// MARK: - Platform Helpers

private extension View {
    @ViewBuilder
    func inlineTitleIfiOS() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
