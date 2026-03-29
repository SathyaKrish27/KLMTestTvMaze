//
//  Show.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//

import Foundation

// MARK: - Domain Model
struct Show: Identifiable, Codable, Equatable, Sendable {
    
    let id: Int
    let name: String
    let summary: String?
    let imageURL: URL?
    let rating: Double?
    let genres: [String]
    let premiered: Date?

    // MARK: - Custom Decoding
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        // Raw values
        let rawSummary = try? container.decode(String.self, forKey: .summary)
        let rawGenres = try? container.decode([String].self, forKey: .genres)
        let rawPremiered = try? container.decode(String.self, forKey: .premiered)

        let ratingContainer = try? container.nestedContainer(keyedBy: RatingKeys.self, forKey: .rating)
        let imageContainer = try? container.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)

        // Transformations
        summary = rawSummary
        genres = rawGenres ?? []

        if let dateString = rawPremiered {
            premiered =  ShowUtils.parseDate(dateString)
        } else {
            premiered = nil
        }

        rating = try? ratingContainer?.decode(Double.self, forKey: .average)

        if let imageString = try? imageContainer?.decode(String.self, forKey: .medium) {
            imageURL = URL(string: imageString)
        } else {
            imageURL = nil
        }
    }

    // MARK: - Encoding (for caching)
    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(summary, forKey: .summary)
        try container.encode(genres, forKey: .genres)
        try container.encodeIfPresent(premiered, forKey: .premiered)

        var ratingContainer = container.nestedContainer(keyedBy: RatingKeys.self, forKey: .rating)
        try ratingContainer.encodeIfPresent(rating, forKey: .average)

        var imageContainer = container.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)
        try imageContainer.encodeIfPresent(imageURL?.absoluteString, forKey: .medium)
    }
}

// MARK: - Coding Keys
private extension Show {
    
    enum CodingKeys: String, CodingKey {
        case id, name, summary, genres, premiered, rating, image
    }

    enum RatingKeys: String, CodingKey {
        case average
    }

    enum ImageKeys: String, CodingKey {
        case medium
    }
}

// MARK: - Helpers (Concurrency Safe)
private enum ShowUtils {
    
    nonisolated static let parseStrategy = Date.ParseStrategy(
        format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)", timeZone: .autoupdatingCurrent
    )
    
    nonisolated static func parseDate(_ string: String?) -> Date? {
        guard let string else { return nil }
        return try? Date(string, strategy: parseStrategy)
    }
}

extension Show {
    
    init(
        id: Int,
        name: String,
        summary: String? = nil,
        imageURL: URL? = nil,
        rating: Double? = nil,
        genres: [String] = [],
        premiered: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.imageURL = imageURL
        self.rating = rating
        self.genres = genres
        self.premiered = premiered
    }
}
