//
//  MockNetworkService.swift
//  ShowSphere
//

import Testing
@testable import AirFranceInterviewTest

// MARK: - Mocks

final class MockNetworkService: NetworkService {
    
    var result: Result<[Show], Error> = .success([])
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T: Decodable {
        switch result {
        case .success(let shows):
            return shows as! T
        case .failure(let error):
            throw error
        }
    }
}

actor MockCacheService: CacheService {
    
    private var storage: [String: Any] = [:]
    var savedKey: String?
    
    func save<T>(_ data: T, for key: String) async where T: Codable & Sendable {
        storage[key] = data
        savedKey = key
    }
    
    func load<T>(for key: String) async -> T? where T: Codable & Sendable {
        storage[key] as? T
    }
    
    func clear(for key: String) async {
        storage.removeValue(forKey: key)
    }
}

// MARK: - Tests

struct ShowRepositoryTests {
    
    @Test
    func fetchShows_success_savesToCache() async throws {
        let network = MockNetworkService()
        let cache = MockCacheService()
        
        let expectedShows = await [Show(id: 1, name: "Test Show")]
        network.result = .success(expectedShows)
        
        let repo = await ShowRepository(network: network, cache: cache)
        
        let result = try await repo.fetchShows()
        
        #expect(result == expectedShows)
        
        let cached: [Show]? = await cache.load(for: "all_shows")
        #expect(cached == expectedShows)
    }
    
    @Test
    func fetchShows_networkFails_returnsCached() async throws {
        let network = MockNetworkService()
        let cache = MockCacheService()
        
        let cachedShows = await [Show(id: 2, name: "Cached Show")]
        await cache.save(cachedShows, for: "all_shows")
        
        network.result = .failure(MockError.networkError)
        
        let repo = await ShowRepository(network: network, cache: cache)
        
        let result = try await repo.fetchShows()
        
        #expect(result == cachedShows)
    }
    
    @Test
    func fetchShows_networkFails_noCache_throwsError() async {
        let network = MockNetworkService()
        let cache = MockCacheService()
        
        network.result = .failure(MockError.networkError)
        
        let repo = await ShowRepository(network: network, cache: cache)
        
        await #expect(throws: MockError.networkError) {
            try await repo.fetchShows()
        }
    }
}

// MARK: - Helpers

enum MockError: Error, Equatable {
    case networkError
    case testError
}
