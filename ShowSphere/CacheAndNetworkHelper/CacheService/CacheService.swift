//
//  CacheService.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//

import Foundation

// MARK: - Cache Protocol
protocol CacheService {
    func save<T: Codable & Sendable>(_ data: T, for key: String) async
    func load<T: Codable & Sendable>(for key: String) async -> T?
    func clear(for key: String) async
}

actor FileCacheService: CacheService {
    
    private let directory: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        guard let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("❌ Unable to access cache directory")
        }
        self.directory = dir
    }
    
    func save<T: Codable & Sendable>(_ data: T, for key: String) async {
        let url = fileURL(for: key)
        
        do {
            let encoded = try encoder.encode(data)
            try encoded.write(to: url, options: [.atomic])
        } catch {
            print("Save failed: \(error.localizedDescription)")
        }
    }
    
    func load<T: Codable & Sendable>(for key: String) async -> T? {
        let url = fileURL(for: key)
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            return nil
        }
    }
    
    func clear(for key: String) async {
        let url = fileURL(for: key)
        try? FileManager.default.removeItem(at: url)
    }
    
    private func fileURL(for key: String) -> URL {
        let safeKey = key.replacingOccurrences(of: "[^a-zA-Z0-9_-]", with: "_", options: .regularExpression)
        return directory.appendingPathComponent(safeKey).appendingPathExtension("json")
    }
}
