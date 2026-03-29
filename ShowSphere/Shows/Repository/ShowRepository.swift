//
//  ShowRepository.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//


import Foundation

protocol ShowRepositoryProtocol {
    func fetchShows() async throws -> [Show]
}

final class ShowRepository: ShowRepositoryProtocol {
    
    private let network: NetworkService
    private let cache: CacheService
    
    init(network: NetworkService, cache: CacheService) {
        self.network = network
        self.cache = cache
    }
    
    func fetchShows() async throws -> [Show] {
        let key = "all_shows"
        
        do {
            let shows: [Show] = try await network.request(.shows(page: 0))
            await cache.save(shows, for: key)
           
            return shows
        } catch {
            if let cached: [Show] = await cache.load(for: key) {
                return cached
            }
            throw error
        }
    }
}
